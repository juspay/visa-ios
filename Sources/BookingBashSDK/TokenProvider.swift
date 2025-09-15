//
//  xorEncrypt.swift
//  VisaActivity
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
        guard let path = Bundle.main.path(forResource: "Token", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let encrypted = "DxggDABSNA16Iy4ZNwAoUxFTOxw3EwIuHhIsJTcdBh8dJiAENw4rCCUyKz0MAQoxDxgrHgkINgkgYigkK1QtIT8VAD0VDzoVWEk="
        return encrypted.xorDecrypt(key: "MySecretKey") // same key used when encrypting
    }
}
