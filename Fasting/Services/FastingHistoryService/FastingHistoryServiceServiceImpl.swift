//  
//  FastingHistoryServiceServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//
import Foundation
import Dependencies

class FastingHistoryServiceImpl: FastingHistoryService {
    @Dependency(\.fastingIntervalHistoryRepository) private var fastingIntervalHistoryRepository

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
}
