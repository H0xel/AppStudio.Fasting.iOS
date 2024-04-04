//
//  WeightService.swift
//  
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import Foundation
import AppStudioModels

public protocol WeightService {
    func history(from startDate: Date, until endDate: Date) async throws -> [Date: WeightHistory]
    func history(byDate date: Date) async throws -> WeightHistory?
    func history(exactDate date: Date) async throws -> WeightHistory?
    func save(history: WeightHistory) async throws -> WeightHistory
    func history(for weeks: [Week]) async throws -> [Date: WeightHistory]
    func history(from startDate: Date, until endDate: Date) async throws -> [WeightHistory] 
    func updateTrueWeight(after date: Date) async throws
    func deleteAll() async throws
    func weightHistoryObserver() -> WeightHistoryObserver
    func delete(byId id: String) async throws
}
