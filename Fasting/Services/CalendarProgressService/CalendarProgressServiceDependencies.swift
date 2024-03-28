//
//  CalendarProgressServiceDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 12.03.2024.
//

import Foundation
import Dependencies
import HealthOverview

extension DependencyValues {
    var calendarProgressService: CalendarProgressService {
        self[CalendarProgressServiceKey.self]
    }
}

private enum CalendarProgressServiceKey: DependencyKey {
    static let liveValue = CalendarProgressServiceImpl()
}
