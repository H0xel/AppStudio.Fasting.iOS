//
//  WeightGoal.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import AppStudioModels

public struct WeightGoal {
    public let id: String
    public let dateCreated: Date
    public let goal: Double
    public let weightUnit: WeightUnit

    public init(id: String, dateCreated: Date, goal: Double, weightUnit: WeightUnit) {
        self.id = id
        self.dateCreated = dateCreated
        self.goal = goal
        self.weightUnit = weightUnit
    }

    public init(goal: Double, weightUnit: WeightUnit) {
        self.id = UUID().uuidString
        self.dateCreated = .now
        self.goal = goal
        self.weightUnit = weightUnit
    }
}

extension WeightGoal {

    var goalWeight: WeightMeasure {
        .init(value: goal, units: weightUnit)
    }

    static var empty: WeightGoal {
        .init(goal: 0, weightUnit: .lb)
    }
}
