//  
//  MenstrualCalendarDependencies.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//

import Dependencies

extension DependencyValues {
    var menstrualCalendarService: MenstrualCalendarService {
        self[MenstrualCalendarServiceKey.self]
    }
}

private enum MenstrualCalendarServiceKey: DependencyKey {
    static var liveValue: MenstrualCalendarService = MenstrualCalendarServiceImpl()
}
