//
//  WeightGoalService.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation

public protocol WeightGoalService {
    func currentGoal() async throws -> WeightGoal
    func save(_ goal: WeightGoal) async throws -> WeightGoal
}
