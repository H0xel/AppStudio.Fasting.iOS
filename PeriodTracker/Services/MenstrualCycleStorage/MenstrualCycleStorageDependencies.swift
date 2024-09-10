//  
//  MenstrualCycleStorageDependencies.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//

import Dependencies

extension DependencyValues {
    var menstrualCycleStorage: MenstrualCycleStorage {
        self[MenstrualCycleStorageKey.self]
    }
}

private enum MenstrualCycleStorageKey: DependencyKey {
    static var liveValue: MenstrualCycleStorage = MenstrualCycleStorageImpl()
}
