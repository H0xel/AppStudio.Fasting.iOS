//
//  EarlyTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies
import AICoach
import HealthProgress

final class EarlyTimeInitializers: Initializers {

    @Dependency(\.paywallServiceInitializer) private var paywallServiceInitializer
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer

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
            SubscriptionServiceInitializer(),
            NotificationCenterInitializer(),
            paywallServiceInitializer,
            fastingParametersInitializer,
            AppearanceInitializer(),
            QuickActionInitializer(),
            AICoachInitializer(),
            HealthProgressInitializer()
        ]
    }
}
