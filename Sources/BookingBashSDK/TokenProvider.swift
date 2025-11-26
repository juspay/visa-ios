import Foundation

extension String {
    func xorDecrypt(key: String) -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        let keyBytes = Array(key.utf8)
        let encryptedBytes = Array(data)
        let decrypted = encryptedBytes.enumerated().map { i, byte in
            byte ^ keyBytes[i % keyBytes.count]
        }
        return String(bytes: decrypted, encoding: .utf8) ?? ""
    }
}

struct TokenProvider {
    static func getAuthHeader() -> String? {
        var url: URL?

        // 1️⃣ Try Bundle.module first (works only when compiled via Swift Package)
        #if SWIFT_PACKAGE
        url = Bundle.module.url(forResource: "Token", withExtension: "plist")
        #endif

        // 2️⃣ Fallback to Bundle.main (App / Framework usage)
        if url == nil {
            url = Bundle.main.url(forResource: "Token", withExtension: "plist")
        }

        guard let fileUrl = url,
              let dict = NSDictionary(contentsOf: fileUrl),
              let encrypted = dict["authHeader"] as? String else {
            return nil
        }

        return encrypted.xorDecrypt(key: "BookingBash")
    }
}
