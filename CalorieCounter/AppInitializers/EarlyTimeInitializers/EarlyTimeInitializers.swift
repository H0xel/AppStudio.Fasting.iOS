//
//  EarlyTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class EarlyTimeInitializers: Initializers {

    @Dependency(\.paywallServiceInitializer) private var paywallServiceInitializer

    func initializers() -> [AppInitializer] {
        [
            DatabaseInitializer(),
            PreferencesInitializer(),
            FirebaseInitializer(),
            CrashlyticsInitializer(),
            AppSyncServiceInitializer(),
            AccountProviderInitializer(),
            MobileDeviceDataProviderInitializer(),
            TrackerServiceInitializer(),
            SubscriptionServiceInitializer(),
            paywallServiceInitializer,
            QuickActionInitializer(),
            AppearenceInitializer()
        ]
    }
}
