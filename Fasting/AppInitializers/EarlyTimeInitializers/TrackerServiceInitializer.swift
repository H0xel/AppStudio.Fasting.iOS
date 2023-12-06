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
        let id = UIDevice.current.isSandbox 
        ? "stg_\(accountIdProvider.accountId)".lowercased()
        : accountIdProvider.accountId.lowercased()
        trackerService.set(userId: id)
        analyticKeyStore.accountId = id
    }
}
