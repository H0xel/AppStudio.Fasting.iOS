//
//  TrackerServiceDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 23.10.2023.
//

import Dependencies
import AppStudioAnalytics
import MunicornAPI
import UIKit

extension DependencyValues {
    public var trackerService: TrackerService {
        self[TrackerServiceKey.self]
    }
}

private enum TrackerServiceKey: DependencyKey {
    static var liveValue: TrackerService {
        @Dependency(\.obfuscator) var obfusactor
        @Dependency(\.analyticKeyStore) var analyticKeyStore

        let amplitudeKey = obfusactor.reveal(
            key: UIDevice.current.isSimulator
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
    }
}
