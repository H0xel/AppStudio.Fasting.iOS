//  
//  FastingHistoryServiceServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//
import Foundation
import Dependencies

class FastingHistoryServiceServiceImpl: FastingHistoryServiceService {
    @Dependency(\.fastingIntervalHistoryRepository) private var fastingIntervalHistoryRepository

    func saveHistory(interval: FastingInterval, finishedAt finishedDate: Date) async throws {
        let history = FastingIntervalHistory(
            currentDate: .now,
            startedDate: interval.startDate,
            finishedDate: finishedDate,
            plan: interval.plan)

        try await fastingIntervalHistoryRepository.save(history: history)
    }
}
