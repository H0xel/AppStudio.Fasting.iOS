//  
//  MenstrualCycleCalendarRepositoryDependencies.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 06.09.2024.
//

import Dependencies

extension DependencyValues {
    var menstrualCycleCalendarRepository: MenstrualCycleCalendarRepository {
        self[MenstrualCycleCalendarRepositoryKey.self]
    }
}

private enum MenstrualCycleCalendarRepositoryKey: DependencyKey {
    static var liveValue: MenstrualCycleCalendarRepository = MenstrualCycleCalendarRepositoryImpl()
    static var testValue: MenstrualCycleCalendarRepository = MenstrualCycleCalendarRepositoryImpl()
}
