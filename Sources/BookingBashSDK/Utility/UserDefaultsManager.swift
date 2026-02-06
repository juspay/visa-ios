//
//  UserDefaultsManager.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 20/01/26.
//

import Foundation

enum UserDefaultsKey: String {
    case activeCurrency
    case salutationTitle
}

final class UserDefaultsManager {

    // MARK: - Singleton
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private init() {}


    // MARK: - Set Value
    func set<T>(_ value: T, for key: String) {
        defaults.set(value, forKey: key)
    }

    // MARK: - Get Value
    func get<T>(for key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }

    // MARK: - Remove Value
    func remove(for key: String) {
        defaults.removeObject(forKey: key)
    }

    // MARK: - Clear All UserDefaults
    func clearAll() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        defaults.removePersistentDomain(forName: bundleID)
    }
}
