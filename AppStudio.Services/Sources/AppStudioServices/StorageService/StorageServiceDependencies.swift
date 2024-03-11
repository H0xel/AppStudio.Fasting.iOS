//
//  StorageServiceDependencies.swift
//
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import MunicornFoundation
import Dependencies

public  extension DependencyValues {
    var storageService: StorageService {
        self[StorageServiceKey.self]
    }
}

private enum StorageServiceKey: DependencyKey {
    static let liveValue: StorageService = DependencyContainer.container.storageService
    static let testValue: StorageService = DependencyContainer.container.storageService
}
