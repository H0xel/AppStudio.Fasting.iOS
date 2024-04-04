//
//  WeightServiceImpl.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import AppStudioModels
import Dependencies

class WeightServiceImpl: WeightService {

    @Dependency(\.weightHistoryRepository) private var weightHistoryRepository
    @Dependency(\.trueWeightCalculationService) private var trueWeightCalculationService
    @Dependency(\.weightInterpolationService) private var weightInterpolationService

    func weightHistoryObserver() -> WeightHistoryObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = WeightHistoryObserver(coreDataService: coreDataService)
        let request = WeightHistory.request()
        request.sortDescriptors = [.init(key: "historyDate", ascending: true)]
        observer.fetch(request: request)
        return observer
    }

    func history(from startDate: Date, until endDate: Date) async throws -> [Date: WeightHistory] {
        var result: [Date: WeightHistory] = [:]
        var currentDay = startDate
        while currentDay <= endDate.endOfDay {
            if let history = try await weightHistoryRepository.history(byDate: currentDay) {
                result[currentDay] = history
            }
            currentDay = currentDay.add(days: 1)
            await Task.yield()
        }
        return result
    }

    func history(from startDate: Date, until endDate: Date) async throws -> [WeightHistory] {
        let history = try await weightHistoryRepository.history(from: startDate, until: endDate)
        return filteredHistory(Array(history.reversed()))
    }

    func history(byDate date: Date) async throws -> WeightHistory? {
        try await weightHistoryRepository.history(byDate: date)
    }

    func history(exactDate date: Date) async throws -> WeightHistory? {
        try await weightHistoryRepository.history(exactDate: date)
    }

    func save(history: WeightHistory) async throws -> WeightHistory {
        let history = try await weightHistoryRepository.save(history: history)
        let trueWeight = try await trueWeightCalculationService.calculate(history: history)
        let updatedWeight = history.updated(trueWeight: trueWeight)
        return try await weightHistoryRepository.save(history: updatedWeight)
    }

    func updateTrueWeight(after date: Date) async throws {
        let weightHistory = try await history(from: date)

        for history in weightHistory {
            let trueWeight = try await trueWeightCalculationService.calculate(history: history)
            _ = try await weightHistoryRepository.save(history: history.updated(trueWeight: trueWeight))
            await Task.yield()
        }
    }

    func history(for weeks: [Week]) async throws -> [Date: WeightHistory] {
        try await withThrowingTaskGroup(
            of: (Date, WeightHistory?).self,
            returning: [Date: WeightHistory].self
        ) { [weak self] group in
            guard let self else { return [:] }
            let days = weeks.flatMap { $0.days }
            for day in days {
                group.addTask {
                    try await (day, self.weightHistoryRepository.history(exactDate: day))
                }
            }
            var results: [Date: WeightHistory] = [:]
            for try await result in group {
                results[result.0] = result.1
            }
            return results
        }
    }

    func deleteAll() async throws {
        try await weightHistoryRepository.deleteAll()
    }

    func delete(byId id: String) async throws {
        try await weightHistoryRepository.delete(byId: id)
    }

    private func history(from date: Date) async throws -> [WeightHistory] {
        let weightHistory = try await weightHistoryRepository.history(from: date).reversed()
        return filteredHistory(Array(weightHistory))
    }

    private func filteredHistory(_ weightHistory: [WeightHistory]) -> [WeightHistory] {
        var historyDict: [Date: WeightHistory] = [:]

        for history in weightHistory {
            historyDict[history.historyDate] = history
        }

        return historyDict.keys.sorted().compactMap { historyDict[$0] }
    }
}
