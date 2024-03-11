//
//  KeyValueStorageDependency.swift
//
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import Dependencies
import ABTesting

public extension DependencyValues {
    var keyValueStorage: KeyValueStorage {
        self[KeyValueStorageKey.self]
    }
}

private enum KeyValueStorageKey: DependencyKey {
    static let liveValue: KeyValueStorage = KeyValueStorageImpl()
    static let testValue: KeyValueStorage = KeyValueStorageImpl()
}
