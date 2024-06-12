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
            ? "6e46314d440f57541418131176034354101f1016241546765355555203415212"
            : "69466716460b5c5f121c1444750217501b4e131a2544407657545c0604400046"
        )
        let appsflyerAppId = obfusactor.reveal(key: "6d16644040505e571615")
        let appsflyerDevKey = obfusactor.reveal(key: "161b19393e381a556a796d651d5403044c7575730c33")

        let accountId = ""

        return TrackerServiceImpl(
            amplitudeKey: amplitudeKey,
            appsflyerAppId: appsflyerAppId,
            appsflyerDevKey: appsflyerDevKey,
            accountId: accountId
        )
    }()
}
