//
//  EarlyTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies
import AICoach

final class EarlyTimeInitializers: Initializers {

    @Dependency(\.paywallServiceInitializer) private var paywallServiceInitializer

    func initializers() -> [AppInitializer] {
        [
            DatabaseInitializer(),
            AICoachDatabaseInitializer(),
            PreferencesInitializer(),
            FirebaseInitializer(),
            CrashlyticsInitializer(),
            AppSyncServiceInitializer(),
            AccountProviderInitializer(),
            MobileDeviceDataProviderInitializer(),
            TrackerServiceInitializer(),
            NewSubscriptionInitializerService(),
            paywallServiceInitializer,
            QuickActionInitializer(),
            AppearenceInitializer(),
            AICoachInitializer(),
            NotificationCenterInitializer()
        ]
    }
}
