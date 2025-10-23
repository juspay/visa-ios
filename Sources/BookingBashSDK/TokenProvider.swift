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
        print("AA4cAgpONjtQPjoUKTU+PF5RDzU1ARgFKhIwOiEvLxkhcyE4LQUgHRtTPTwhFjZZJFw9KCwJJwU2FiYTDVIMJiUDDTs9ADAZWn8=".xorDecrypt(key: "BookingBash"))
        return "AA4cAgpONjtQPjoUKTU+PF5RDzU1ARgFKhIwOiEvLxkhcyE4LQUgHRtTPTwhFjZZJFw9KCwJJwU2FiYTDVIMJiUDDTs9ADAZWn8=".xorDecrypt(key: "BookingBash")
    }
}
