//
//  FastingIntervalHistoryRepositoryImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Foundation
import MunicornCoreData
import Dependencies

typealias FastingIntervalHistoryObserver = CoreDataObserver<FastingIntervalHistory>

class FastingIntervalHistoryRepositoryImpl: CoreDataBaseRepository<FastingIntervalHistory> {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }
}

extension FastingIntervalHistoryRepositoryImpl: FastingIntervalHistoryRepository {

    var historyObserver: FastingIntervalHistoryObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = FastingIntervalHistoryObserver(coreDataService: coreDataService)
        let request = FastingIntervalHistory.request()
        request.sortDescriptors = [.init(key: "startedDate", ascending: false)]
        observer.fetch(request: request)
        return observer
    }

    func save(history: FastingIntervalHistory) async throws -> FastingIntervalHistory {
        try await save(history)
    }

    func selectLast(count: Int) async throws -> [FastingIntervalHistory] {
        let request = FastingIntervalHistory.request()
        request.fetchLimit = count
        request.sortDescriptors = [.init(key: "currentDate", ascending: true)]

        return try await select(request: request)
    }

    func history(byId id: String) async throws -> FastingIntervalHistory? {
        try await object(byId: id)
    }

    func select(from date: Date) async throws -> [FastingIntervalHistory] {
        let request = FastingIntervalHistory.request()
        let startDate = date.startOfTheDay
        let endDate = date.endOfDay
        request.predicate = .init(
            format: "startedDate >= %@ AND startedDate <= %@",
            startDate as NSDate,
            endDate as NSDate
        )
        return try await select(request: request)
    }
}
