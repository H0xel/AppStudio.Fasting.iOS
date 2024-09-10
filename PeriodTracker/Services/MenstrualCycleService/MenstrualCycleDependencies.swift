//  
//  MenstrualCycleDependencies.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//

import Dependencies

extension DependencyValues {
    var menstrualCycleService: MenstrualCycleService {
        self[MenstrualCycleServiceKey.self]
    }
}

private enum MenstrualCycleServiceKey: DependencyKey {
    static var liveValue: MenstrualCycleService = MenstrualCycleServiceImpl()
}
