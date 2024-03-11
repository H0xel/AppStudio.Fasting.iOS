//
//  HealthProgressInitializer.swift
//  Fasting
//
//  Created by Denis Khlopin on 08.03.2024.
//

import Dependencies
import HealthProgress

extension HealthProgressInitializer: AppInitializer {
    func initialize() {
        @Dependency(\.trackerService) var trackerService
        initialize(trackerService: trackerService)
    }
}
