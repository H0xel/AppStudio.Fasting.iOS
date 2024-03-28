//
//  HealthOverviewInitializer+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import Foundation
import HealthOverview
import Dependencies

extension HealthOveviewInitializer: AppInitializer {
    func initialize() {
        @Dependency(\.calendarProgressService) var calendarProgressService
        initialize(calendarProgressService: calendarProgressService)
    }
}
