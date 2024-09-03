//
//  EarlyTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies

final class EarlyTimeInitializers: Initializers {

    func initializers() -> [AppInitializer] {
        [
            PreferencesInitializer(),
            FirebaseInitializer(),
            CrashlyticsInitializer(),
            AppSyncServiceInitializer(),
            AccountProviderInitializer(),
            MobileDeviceDataProviderInitializer(),
            TrackerServiceInitializer(),
            NewSubscriptionInitializerService()
        ]
    }
}
