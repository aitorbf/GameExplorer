//
//  KeychainService.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//


import Foundation
import Security

enum KeychainService {
    
    /// Saves a Codable object in the keychain.
    @discardableResult
    static func save<T: Codable>(_ object: T, for key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(object) else { return false }

        // Remove existing item if it exists
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(query)

        // Add the new encoded data
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        return SecItemAdd(attributes, nil) == errSecSuccess
    }

    /// Loads a Codable object from the keychain.
    static func load<T: Codable>(_ type: T.Type, for key: String) -> T? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let object = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }

        return object
    }

    /// Deletes an item from the keychain.
    @discardableResult
    static func delete(_ key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        return SecItemDelete(query) == errSecSuccess
    }
}
