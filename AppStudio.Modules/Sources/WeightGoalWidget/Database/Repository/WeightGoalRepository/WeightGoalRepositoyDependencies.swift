//
//  WeightGoalRepositoyDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies

extension DependencyValues {
    var weightGoalRepository: WeightGoalRepository {
        self[WeightGoalRepositoryKey.self]
    }
}

private enum WeightGoalRepositoryKey: DependencyKey {
    static let liveValue = WeightGoalRepositoryImpl()
}
