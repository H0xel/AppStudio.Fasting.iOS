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
        @Dependency(\.analyticKeyStore) var analyticKeyStore

        let amplitudeKey = obfusactor.reveal(
            key: UIDevice.current.isSandbox
            ? "3d12644614580d05474910442005425515141315761616705558555050110316"
            : "3e433147105e5603401a411026021600151f104176484977045e5150514c5d43"
        )
        let appsflyerAppId = obfusactor.reveal(key: "6d166444465f5e53141f")
        let appsflyerDevKey = obfusactor.reveal(key: "161b19393e381a556a796d651d5403044c7575730c33")
        let accountId = analyticKeyStore.accountId ?? ""

        return TrackerServiceImpl(
            amplitudeKey: amplitudeKey,
            appsflyerAppId: appsflyerAppId,
            appsflyerDevKey: appsflyerDevKey,
            accountId: accountId
        )
    }()
}
