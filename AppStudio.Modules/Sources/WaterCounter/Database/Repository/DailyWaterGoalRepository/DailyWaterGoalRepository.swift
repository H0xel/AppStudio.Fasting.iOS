//  
//  DailyWaterGoalRepository.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//
import Foundation

protocol DailyWaterGoalRepository {
    func goal() async throws -> DailyWaterGoal
    func goal(at date: Date) async throws -> DailyWaterGoal?
    func goals(from: Date, to: Date) async throws -> [DailyWaterGoal]
    func set(goal: DailyWaterGoal) async throws -> DailyWaterGoal
}
