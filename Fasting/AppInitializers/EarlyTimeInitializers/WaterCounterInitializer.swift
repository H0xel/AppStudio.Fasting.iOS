//
//  WaterCounterInitializer.swift
//  Fasting
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Dependencies
import WaterCounter

extension WaterCounterDatabaseInitializer: AppInitializer {}

extension WaterCounterInitializer: AppInitializer {

    func initialize() {
        @Dependency(\.onboardingService) var onboardingService
        if let waterIntakeService = onboardingService as? WaterIntakeService {
            initialize(waterIntakeService: waterIntakeService)
        }

    }
}
