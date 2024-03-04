//
//  TrackerServiceDependencies.swift
//  CalorieCounter
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
