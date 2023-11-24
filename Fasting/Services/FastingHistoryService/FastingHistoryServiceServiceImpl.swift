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
}
