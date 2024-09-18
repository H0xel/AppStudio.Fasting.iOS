//
//  TrackerServiceInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies
import UIKit
import AppStudioServices
import AppStudioAnalytics

final class TrackerServiceInitializer: AppInitializer {
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.analyticKeyStore) private var analyticKeyStore

    func initialize() {
        TrackerServiceKey.liveValue = trackerServiceLiveValue
        trackerService.initialize()
        trackerService.set(userId: accountIdProvider.accountId)
    }

    private var trackerServiceLiveValue: TrackerServiceImpl = {
        @Dependency(\.obfuscator) var obfusactor

        let amplitudeKey = obfusactor.reveal(
            key: UIDevice.current.isSandbox
            ? ""
            : ""
        )
        let appsflyerAppId = obfusactor.reveal(key: "")
        let appsflyerDevKey = obfusactor.reveal(key: "")

        let accountId = ""

        return TrackerServiceImpl(
            amplitudeKey: amplitudeKey,
            appsflyerAppId: appsflyerAppId,
            appsflyerDevKey: appsflyerDevKey,
            accountId: accountId
        )
    }()
}
