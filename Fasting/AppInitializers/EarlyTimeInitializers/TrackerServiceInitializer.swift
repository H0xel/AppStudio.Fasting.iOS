//
//  TrackerServiceInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class TrackerServiceInitializer: AppInitializer {
    @Dependency(\.trackerService) private var trackerService

    func initialize() {
        trackerService.initialize()
    }
}
