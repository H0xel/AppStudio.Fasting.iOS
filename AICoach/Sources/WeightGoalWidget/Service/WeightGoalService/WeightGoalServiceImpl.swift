//
//  WeightGoalServiceImpl.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies

class WeightGoalServiceImpl: WeightGoalService {
    @Dependency(\.weightGoalRepository) private var weightGoalRepository

    func currentGoal() async throws -> WeightGoal {
        let goal = try await weightGoalRepository.currentGoal()
        return goal ?? .empty
    }

    func save(_ goal: WeightGoal) async throws -> WeightGoal {
        try await weightGoalRepository.save(goal)
    }

    func goals() async throws -> [WeightGoal] {
        try await weightGoalRepository.goals()
    }
}
