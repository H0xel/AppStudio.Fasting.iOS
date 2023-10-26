//
//  TrackerServiceDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 23.10.2023.
//

import Dependencies
import AppStudioAnalytics
import MunicornAPI

extension DependencyValues {
    public var trackerService: TrackerService {
        self[TrackerServiceKey.self]
    }
}

private enum TrackerServiceKey: DependencyKey {
    static var liveValue: TrackerService {
        @Dependency(\.obfuscator) var obfusactor

        // TODO: добавить все необходимы ключи

        let amplitudeKey = obfusactor.obfuscated(string: "")
        let appsflyerAppId = obfusactor.obfuscated(string: "")
        let appsflyerDevKey = obfusactor.obfuscated(string: "")
        let accountId = ""

        return TrackerServiceImpl(
            amplitudeKey: amplitudeKey,
            appsflyerAppId: appsflyerAppId,
            appsflyerDevKey: appsflyerDevKey,
            accountId: accountId
        )
    }
}
