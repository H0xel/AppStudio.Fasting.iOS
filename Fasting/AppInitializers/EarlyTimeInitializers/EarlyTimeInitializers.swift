//
//  EarlyTimeInitializers.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import Dependencies
import AICoach
import HealthOverview
import HealthProgress
import WaterCounter
import FastingWidget
import WeightWidget
import WeightGoalWidget

final class EarlyTimeInitializers: Initializers {

    @Dependency(\.paywallServiceInitializer) private var paywallServiceInitializer
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer

    func initializers() -> [AppInitializer] {
        [
            DatabaseInitializer(),
            AICoachDatabaseInitializer(),
            WaterCounterDatabaseInitializer(),
            WeightWidgetDatabaseInitializer(),
            WeightGoalWidgetDatabaseInitializer(),
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
            HealthOveviewInitializer(),
            HealthProgressInitializer(),
            FastingWidgetInitializer(),
            WaterCounterInitializer()
        ]
    }
}
