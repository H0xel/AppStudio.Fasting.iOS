//
//  DatabaseDependencies.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 04.09.2024.
//

import Dependencies
import MunicornCoreData

extension DependencyValues {
    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
    static let testValue = MunicornCoreDataFactory.instance.coreDataService
}
