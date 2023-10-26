//
//  IntercomInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class IntercomInitializer: AppInitializer {
    @Dependency(\.intercomDataStorage) private var intercomDataStorage
    @Dependency(\.intercomService) private var intercomService

    public init() {}

    public func initialize() {
        intercomDataStorage.initialize()
        intercomService.initialize()
    }
}
