//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies

public extension DependencyValues {
    var weightGoalService: WeightGoalService {
        self[WeightGoalServiceKey.self]
    }
}

private enum WeightGoalServiceKey: DependencyKey {
    static let liveValue = WeightGoalServiceImpl()
}
