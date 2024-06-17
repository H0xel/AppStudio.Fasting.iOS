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
import Explore

final class EarlyTimeInitializers: Initializers {
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer

    func initializers() -> [AppInitializer] {
        [
            DatabaseInitializer(),
            AICoachDatabaseInitializer(),
            WaterCounterDatabaseInitializer(),
            WeightWidgetDatabaseInitializer(),
            WeightGoalWidgetDatabaseInitializer(),
            ExploreDatabaseInitializer(),
            PreferencesInitializer(),
            FirebaseInitializer(),
            CrashlyticsInitializer(),
            AppSyncServiceInitializer(),
            AccountProviderInitializer(),
            NewSubscriptionInitializerService(),
            MobileDeviceDataProviderInitializer(),
            TrackerServiceInitializer(),
            NotificationCenterInitializer(),
            fastingParametersInitializer,
            AppearanceInitializer(),
            QuickActionInitializer(),
            AICoachInitializer(),
            HealthOveviewInitializer(),
            HealthProgressInitializer(),
            FastingWidgetInitializer(),
            WaterCounterInitializer(),
            ExploreInitializer()
        ]
    }
}
