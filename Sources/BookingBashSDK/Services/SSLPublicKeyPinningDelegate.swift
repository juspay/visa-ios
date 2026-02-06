//
//  SSLPublicKeyPinningDelegate.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 03/12/25.
//

import Foundation
import Security
import CommonCrypto

// MARK: - SSL Pinning Delegate
final class SSLPublicKeyPinningDelegate: NSObject, URLSessionDelegate {

    // MARK: - Pinned Public Key
    private var pinnedPublicKeyHash: String {
        return ConfigurationManager.shared.sslKey
    }

    // MARK: - URLSessionDelegate
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {

        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            reject("Failed to get server trust", completionHandler)
            return
        }

        // Get leaf certificate only (first in chain)
        guard let leafCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            reject("Failed to get leaf certificate", completionHandler)
            return
        }

        // Compute SHA-256 of leaf public key
        if let liveHash = getPublicKeyHash(from: leafCertificate), liveHash == pinnedPublicKeyHash {
            accept(serverTrust, completionHandler)
        } else {
            // Optional: print the live hash for debugging
            if let liveHash = getPublicKeyHash(from: leafCertificate) {
//                print("🔐 Live public key hash: \(liveHash)")
            }
            reject("No matching pinned public key found", completionHandler)
        }
    }

    // MARK: - Compute Public Key Hash
    private func getPublicKeyHash(from certificate: SecCertificate) -> String? {
        guard let publicKey = SecCertificateCopyKey(certificate),
              let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
            return nil
        }

        return "sha256/" + sha256(publicKeyData)
    }

    private func sha256(_ data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }

    // MARK: - Accept / Reject
    private func accept(_ trust: SecTrust, _ handler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("✅ Public key matched. Trusting connection.")
        handler(.useCredential, URLCredential(trust: trust))
    }

    private func reject(_ message: String, _ handler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("❌ SSL Pinning Failed: \(message)")
        handler(.cancelAuthenticationChallenge, nil)
    }
}
