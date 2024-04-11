//  
//  FastingHistoryServiceServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//
import Foundation
import Dependencies
import Combine

class FastingHistoryServiceImpl: FastingHistoryService {
    @Dependency(\.fastingIntervalHistoryRepository) private var fastingIntervalHistoryRepository

    var historyObserver: FastingIntervalHistoryObserver {
        fastingIntervalHistoryRepository.historyObserver
    }

    func save(history: FastingIntervalHistory) async throws {
        try await fastingIntervalHistoryRepository.save(history: history)
    }

    func saveHistory(interval: FastingInterval,
                     startedAt startedDate: Date,
                     finishedAt finishedDate: Date) async throws {
        let history = FastingIntervalHistory(
            currentDate: .now,
            startedDate: startedDate,
            finishedDate: finishedDate,
            plan: interval.plan)

        try await fastingIntervalHistoryRepository.save(history: history)
    }

    func selectLast(count: Int) async throws -> [FastingIntervalHistory] {
        try await fastingIntervalHistoryRepository.selectLast(count: count)
    }

    func history(for date: Date) async throws -> [FastingIntervalHistory] {
        try await fastingIntervalHistoryRepository.select(from: date)
    }

    func history(byId id: String) async throws -> FastingIntervalHistory? {
        try await fastingIntervalHistoryRepository.history(byId: id)
    }

    func history(for dates: [Date]) async throws -> [Date: FastingIntervalHistory] {
        try await withThrowingTaskGroup(
            of: (Date, [FastingIntervalHistory]).self,
            returning: [Date: FastingIntervalHistory].self
        ) { [weak self] group in
            guard let self else { return [:] }
            for day in dates {
                group.addTask {
                    let history = try await self.history(for: day)
                    return (day, history)
                }
            }
            var result: [Date: FastingIntervalHistory] = [:]
            for try await history in group {
                if let longestFasting = history.1.sorted(by: { $0.timeFasted < $1.timeFasted }).last {
                    result[history.0] = longestFasting
                }
            }
            return result
        }
    }

    func deleteAll() async throws {
        try await fastingIntervalHistoryRepository.deleteAll()
    }

    func delete(byId: String) async throws {
        try await fastingIntervalHistoryRepository.delete(byId: byId)
    }

    func history() async throws -> [FastingIntervalHistory] {
        try await fastingIntervalHistoryRepository.selectAll()
    }
}
