//
//  TrackerServiceInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies
import UIKit

final class TrackerServiceInitializer: AppInitializer {
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.analyticKeyStore) private var analyticKeyStore

    func initialize() {
        trackerService.initialize()
        trackerService.set(userId: accountIdProvider.accountId)
    }
}
