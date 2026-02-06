//
//  ConfigurationManager.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 02/02/26.
//

import Foundation

class ConfigurationManager {
    static let shared = ConfigurationManager()
    
    // Default to Sandbox values to avoid crashes if config fails
    private(set) var baseURL: String = ""
//    "https://travelapi-sandbox.bookingbash.com/services"
    private(set) var sslKey: String = ""
//    "sha256/VcG4ZpvsiI0vGDzYVei+7Nmx90QrkeWK9GcTSJUrGU8="
    private(set) var authHeader: String = "" // Will be loaded from plist
    
    private init() {}
    
    func configure(for environment: String) {
        let envKey = environment.lowercased()
        
        // 1️⃣ Try Bundle.module for Swift Package Manager
        var url: URL?
        #if SWIFT_PACKAGE
        url = Bundle.module.url(forResource: "Token", withExtension: "plist")
        #endif
        
        // 2️⃣ Fallback to Bundle.main (App / Framework usage)
        if url == nil {
            url = Bundle.main.url(forResource: "Token", withExtension: "plist")
        }
        
        guard let plistURL = url,
              let xml = FileManager.default.contents(atPath: plistURL.path),
              let plistData = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any],
              let envDict = plistData[envKey] as? [String: String] else {
            print("⚠️ Configuration for '\(envKey)' not found. Using defaults.")
            return
        }
        
        if let url = envDict["baseURL"] { self.baseURL = url }
        if let key = envDict["sslKey"] { self.sslKey = key }
        if let token = envDict["authHeader"] { self.authHeader = token }
    }
}
