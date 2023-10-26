//
//  DataAssembly.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 02.11.2022.
//

import ABTesting
import MunicornFoundation
import Dependencies

extension DependencyValues {
    var storageService: StorageService {
        self[StorageServiceKey.self]
    }

    var cloudStorage: CloudStorage {
        self[CloudStorageServiceKey.self]
    }

    var keyValueStorage: KeyValueStorage {
        self[KeyValueStorageKey.self]
    }

    var preferencesService: PreferencesService {
        self[PreferencesServiceKey.self]
    }
}

private enum PreferencesServiceKey: DependencyKey {
    static let liveValue: PreferencesService = PreferencesServiceImpl()
    static let testValue: PreferencesService = PreferencesServiceImpl()
}

private enum StorageServiceKey: DependencyKey {
    static let liveValue: StorageService = DependencyContainer.container.storageService
    static let testValue: StorageService = DependencyContainer.container.storageService
}

private enum CloudStorageServiceKey: DependencyKey {
    static let liveValue: CloudStorage = DependencyContainer.container.cloudStorage
    static let testValue: CloudStorage = DependencyContainer.container.cloudStorage
}

private enum KeyValueStorageKey: DependencyKey {
    static let liveValue: KeyValueStorage = KeyValueStorageImpl()
    static let testValue: KeyValueStorage = KeyValueStorageImpl()
}
