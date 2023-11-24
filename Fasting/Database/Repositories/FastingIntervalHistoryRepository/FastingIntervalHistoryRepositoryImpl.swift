//
//  FastingIntervalHistoryRepositoryImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Foundation
import MunicornCoreData
import Dependencies

class FastingIntervalHistoryRepositoryImpl: CoreDataBaseRepository<FastingIntervalHistory> {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }
}

extension FastingIntervalHistoryRepositoryImpl: FastingIntervalHistoryRepository {
    func save(history: FastingIntervalHistory) async throws -> FastingIntervalHistory {
        try await save(history)
    }

    func selectLast(count: Int) async throws -> [FastingIntervalHistory] {
        let request = FastingIntervalHistory.request()
        request.fetchLimit = count
        request.sortDescriptors = [.init(key: "currentDate", ascending: true)]

        return try await select(request: request)
    }
}
