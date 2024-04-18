//
//  WeightHistoryRepositoryImpl.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import MunicornCoreData
import Dependencies

class WeightHistoryRepositoryImpl: CoreDataBaseRepository<WeightHistory>, WeightHistoryRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func history() async throws -> [WeightHistory] {
        let request = WeightHistory.request()
        request.sortDescriptors = [.init(key: "historyDate", ascending: false),
                                   .init(key: "dateCreated", ascending: false)]
        return try await select(request: request)
    }

    func history(from startDate: Date, until endDate: Date) async throws -> [WeightHistory] {
        let request = WeightHistory.request()
        request.predicate = .dateRangePredicate(from: startDate.startOfTheDay,
                                                to: endDate.endOfDay,
                                                dateKey: "historyDate")
        request.sortDescriptors = [.init(key: "historyDate", ascending: false),
                                   .init(key: "dateCreated", ascending: false)]
        return try await select(request: request)
    }

    func history(byDate date: Date) async throws -> WeightHistory? {
        let request = WeightHistory.request()
        request.predicate = .init(format: "historyDate <= %@", date.endOfDay as NSDate)
        request.sortDescriptors = [.init(key: "historyDate", ascending: false),
                                   .init(key: "dateCreated", ascending: false)]
        request.fetchLimit = 1
        return try await select(request: request).first
    }

    func history(exactDate date: Date) async throws -> WeightHistory? {
        let request = WeightHistory.request()
        request.predicate = .dateRangePredicate(from: date.startOfTheDay,
                                                to: date.endOfDay,
                                                dateKey: "historyDate")
        request.sortDescriptors = [.init(key: "historyDate", ascending: false),
                                   .init(key: "dateCreated", ascending: false)]
        request.fetchLimit = 1
        return try await select(request: request).first
    }

    func save(history: WeightHistory) async throws -> WeightHistory {
        try await save(history)
    }

    func history(until date: Date) async throws -> [WeightHistory] {
        let request = WeightHistory.request()
        request.predicate = .init(format: "historyDate <= %@", date.endOfDay as NSDate)
        request.sortDescriptors = [.init(key: "historyDate", ascending: false),
                                   .init(key: "dateCreated", ascending: false)]
        return try await select(request: request)
    }

    func history(from date: Date) async throws -> [WeightHistory] {
        let request = WeightHistory.request()
        request.predicate = .init(format: "historyDate >= %@", date.startOfTheDay as NSDate)
        request.sortDescriptors = [.init(key: "historyDate", ascending: false),
                                   .init(key: "dateCreated", ascending: false)]
        return try await select(request: request)
    }
}
