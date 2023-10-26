//
//  IntercomDependencies.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//

import Dependencies

extension DependencyValues {
    var intercomService: IntercomService {
        self[IntercomServiceKey.self]
    }
}

extension DependencyValues {
    var intercomUpdater: IntercomUpdater {
        self[IntercomUpdaterKey.self]
    }

    var intercomDataStorage: IntercomDataStorage {
        self[IntercomDataStorageKey.self]
    }
}

private enum IntercomServiceKey: DependencyKey {
    static var liveValue: IntercomService = IntercomServiceImpl()
    static var testValue: IntercomService = IntercomServiceImpl()
}

private enum IntercomDataStorageKey: DependencyKey {
    static var liveValue: IntercomDataStorage = IntercomDataStorageImpl()
    static var testValue: IntercomDataStorage = IntercomDataStorageImpl()
}

private enum IntercomUpdaterKey: DependencyKey {
    static let liveValue: IntercomUpdater = IntercomUpdaterImpl()
    static let testValue: IntercomUpdater = IntercomUpdaterImpl()
}
