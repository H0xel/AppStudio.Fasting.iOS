//  
//  TrackerServiceDependencies.swift
//  
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import Dependencies
import AppStudioAnalytics
import UIKit

//extension DependencyValues {
//    public var trackerService: TrackerService {
//        self[TrackerServiceKey.self]
//    }
//}

private enum TrackerServiceKey: DependencyKey {
    static var liveValue: TrackerService {
        @Dependency(\.obfuscator) var obfusactor

// TODO: подумать над регистрацией зависимостей трэкера с разными ключами
// Fasting keys
//        let amplitudeKey = obfusactor.reveal(
//            key: UIDevice.current.isSandbox
//            ? "3d12644614580d05474910442005425515141315761616705558555050110316"
//            : "3e433147105e5603401a411026021600151f104176484977045e5150514c5d43"
//        )
//        let appsflyerAppId = obfusactor.reveal(key: "6d166444465f5e53141f")
//        let appsflyerDevKey = obfusactor.reveal(key: "161b19393e381a556a796d651d5403044c7575730c33")
//        let accountId = analyticKeyStore.accountId ?? ""

        let amplitudeKey = obfusactor.reveal(
            key: UIDevice.current.isSandbox
            ? "6a403712135b5903411c13402759470512191814231448730308575f52120644"
            : "631a6445445a59571b18121b22504703414e454377134322010e0353584356"
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
    }
}
