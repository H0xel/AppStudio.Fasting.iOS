//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Dependencies
import MunicornFoundation
import AppStudioAnalytics
import MunicornCoreData

extension DependencyValues {
    var storageService: StorageService {
        self[StorageServiceKey.self]!
    }

    var cloudStorage: CloudStorage {
        self[CloudStorageKey.self]
    }

    var trackerService: TrackerService {
        self[TrackerServiceKey.self]!
    }

    var userPropertyService: UserPropertyService {
        self[UserPropertyServiceKey.self]!
    }

    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }

    var coachApi: CoachApi {
        self[CoachApiKey.self]!
    }
}

private enum CloudStorageKey: DependencyKey {
    static var liveValue = DependencyContainer.container.cloudStorage
}

enum CoachApiKey: DependencyKey {
    static var liveValue: CoachApi?
}

enum StorageServiceKey: DependencyKey {
    static var liveValue: StorageService?
}

enum TrackerServiceKey: DependencyKey {
    static var liveValue: TrackerService?
}

enum UserPropertyServiceKey: DependencyKey {
    static var liveValue: UserPropertyService?
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
}
