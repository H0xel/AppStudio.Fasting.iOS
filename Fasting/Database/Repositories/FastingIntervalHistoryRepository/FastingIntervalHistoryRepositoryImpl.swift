//
//  FastingIntervalHistoryRepositoryImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Foundation
import MunicornCoreData
import Dependencies

class FastingIntervalHistoryRepositoryImpl: CoreDataBaseRepository<FastingIntervalHistory>, FastingIntervalHistoryRepository {
    
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func save(history: FastingIntervalHistory) async throws -> FastingIntervalHistory {
        try await save(history)
    }

    func selectLast(count: Int) async throws -> [FastingIntervalHistory] {
        var request = FastingIntervalHistory.request()
        request.fetchLimit = count
        request.sortDescriptors = [.init(key: "currentDate", ascending: true)]

        return try await select(request: request)
    }
}
