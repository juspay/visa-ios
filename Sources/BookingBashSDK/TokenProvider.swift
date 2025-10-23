//
//  xorEncrypt.swift
//
//

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
        var path: String?
        
        // Try Bundle.module first (for SPM) - use #if to check compile-time availability
        #if SWIFT_PACKAGE
        path = Bundle.module.path(forResource: "Token", ofType: "plist")
        #endif
        
        // Fallback to Bundle.main (for main app/submodule)
        if path == nil {
            path = Bundle.main.path(forResource: "Token", ofType: "plist")
        }
        
        guard let filePath = path,
              let dict = NSDictionary(contentsOfFile: filePath),
              let encrypted = dict["authHeader"] as? String else {
            print("Token.plist not found in any bundle")
            return nil
        }
        print(encrypted.xorDecrypt(key: "BookingBash"))
        return encrypted.xorDecrypt(key: "BookingBash")
    }
}
