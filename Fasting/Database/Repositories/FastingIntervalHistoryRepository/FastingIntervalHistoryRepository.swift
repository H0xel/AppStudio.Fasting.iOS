//
//  FastingIntervalHistoryRepository.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import MunicornCoreData
import Foundation

protocol FastingIntervalHistoryRepository {
    var historyObserver: FastingIntervalHistoryObserver { get }
    @discardableResult
    func save(history: FastingIntervalHistory) async throws -> FastingIntervalHistory
    func selectLast(count: Int) async throws -> [FastingIntervalHistory]
    func select(from date: Date) async throws -> [FastingIntervalHistory]
    func history(byId id: String) async throws -> FastingIntervalHistory?
    func deleteAll() async throws
    func delete(byId id: String) async throws
    func selectAll() async throws -> [FastingIntervalHistory]
}
