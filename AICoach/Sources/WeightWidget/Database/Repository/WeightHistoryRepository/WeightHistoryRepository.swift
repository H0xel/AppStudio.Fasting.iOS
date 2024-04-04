//
//  WeightHistoryRepository.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation

protocol WeightHistoryRepository {
    func history(from startDate: Date, until endDate: Date) async throws -> [WeightHistory]
    func history(byDate date: Date) async throws -> WeightHistory?
    func save(history: WeightHistory) async throws -> WeightHistory
    func history(until date: Date) async throws -> [WeightHistory]
    func history(from date: Date) async throws -> [WeightHistory]
    func history(exactDate date: Date) async throws -> WeightHistory?
    func deleteAll() async throws
    func delete(byId id: String) async throws
}
