//
//  WeightGoalRepository.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation

protocol WeightGoalRepository {
    func currentGoal() async throws -> WeightGoal?
    func save(_ goal: WeightGoal) async throws -> WeightGoal
    func goals() async throws -> [WeightGoal]
    func deleteAll() async throws
}
