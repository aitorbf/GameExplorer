//
//  KeychainStorage.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//


import Foundation
import Security
import SwiftUI

@propertyWrapper
struct KeychainStorage<T: Codable> {
    
    private let key: String
    private let autoInvalidate: Bool

    var wrappedValue: T? {
        get {
            guard let object: T = KeychainService.load(T.self, for: key) else {
                return nil
            }

            if autoInvalidate, let expirable = object as? Expirable, expirable.isExpired {
                KeychainService.delete(key)
                return nil
            }

            return object
        }

        set {
            if let value = newValue {
                KeychainService.save(value, for: key)
            } else {
                KeychainService.delete(key)
            }
        }
    }

    init(key: String, autoInvalidate: Bool = false) {
        self.key = key
        self.autoInvalidate = autoInvalidate
    }
}
