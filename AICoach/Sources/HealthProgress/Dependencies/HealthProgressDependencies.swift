//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {
    var storageService: StorageService {
        self[StorageServiceKey.self]
    }

    var trackerService: TrackerService {
        self[TrackerServiceKey.self]!
    }

    var userPropertyService: UserPropertyService {
        self[UserPropertyServiceKey.self]!
    }

}

enum StorageServiceKey: DependencyKey {
    static let liveValue: StorageService = DependencyContainer.container.storageService
}

enum TrackerServiceKey: DependencyKey {
    static var liveValue: TrackerService?
}

enum UserPropertyServiceKey: DependencyKey {
    static var liveValue: UserPropertyService?
}
