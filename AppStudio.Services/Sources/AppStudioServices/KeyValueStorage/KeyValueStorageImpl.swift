//
//  KeyValueStorageImpl.swift
//
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import ABTesting
import Foundation

class KeyValueStorageImpl: KeyValueStorage {
    func set<T>(key: String, value: T?) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func get<T>(key: String) -> T? {
        UserDefaults.standard.object(forKey: key) as? T
    }

    func get<T>(key: String, defaultValue: T) -> T {
        guard let value = UserDefaults.standard.object(forKey: key) as? T else {
            return defaultValue
        }
        return value
    }}

