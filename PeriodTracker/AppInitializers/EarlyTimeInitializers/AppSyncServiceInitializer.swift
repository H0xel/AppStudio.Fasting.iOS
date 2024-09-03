//
//  AppSyncServiceInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class AppSyncServiceInitializer: AppInitializer {
    @Dependency(\.appSyncService) private var appSyncService

    public init() {}

    public func initialize() {
        appSyncService.initialize()
    }
}
