//  
//  DailyWaterGoalRepositoryDependencies.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import Dependencies

extension DependencyValues {
    var dailyWaterGoalRepository: DailyWaterGoalRepository {
        self[DailyWaterGoalRepositoryKey.self]
    }
}

private enum DailyWaterGoalRepositoryKey: DependencyKey {
    static var liveValue: DailyWaterGoalRepository = DailyWaterGoalRepositoryImpl()
}
