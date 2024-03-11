//
//  CloudStorageServiceDependencies.swift
//
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import MunicornFoundation
import Dependencies

public extension DependencyValues {
    var cloudStorage: CloudStorage {
        self[CloudStorageServiceKey.self]
    }
}

private enum CloudStorageServiceKey: DependencyKey {
    static let liveValue: CloudStorage = DependencyContainer.container.cloudStorage
    static let testValue: CloudStorage = DependencyContainer.container.cloudStorage
}
