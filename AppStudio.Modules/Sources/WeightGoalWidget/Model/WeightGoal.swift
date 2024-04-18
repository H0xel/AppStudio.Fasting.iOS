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
    public let start: Double
    public let weightUnit: WeightUnit

    public init(id: String, dateCreated: Date, goal: Double, start: Double, weightUnit: WeightUnit) {
        self.id = id
        self.dateCreated = dateCreated
        self.goal = goal
        self.weightUnit = weightUnit
        self.start = start
    }

    public init(goal: Double, start: Double, weightUnit: WeightUnit) {
        self.id = UUID().uuidString
        self.dateCreated = .now
        self.goal = goal
        self.start = start
        self.weightUnit = weightUnit
    }
}

extension WeightGoal {

    var goalWeight: WeightMeasure {
        .init(value: goal, units: weightUnit)
    }

    var startWeight: WeightMeasure {
        .init(value: start, units: weightUnit)
    }

    static var empty: WeightGoal {
        .init(goal: 0, start: 0, weightUnit: .lb)
    }
}
