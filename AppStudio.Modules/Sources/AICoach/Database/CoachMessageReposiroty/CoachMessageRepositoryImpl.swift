//  
//  CoachMessageRepositoryServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import MunicornCoreData
import Dependencies

class CoachMessageRepositoryImpl: CoreDataBaseRepository<CoachMessage>, CoachMessageRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func messages() async throws -> [CoachMessage] {
        try await selectAll()
    }

    func save(_ messages: [CoachMessage]) async throws {
        try await batchSave(messages)
    }

    func coachMessageOsberver() -> CoachMessageObserver {
        let observer = CoachMessageObserver()
        let request = CoachMessage.request()
        request.sortDescriptors = [.init(key: "dateCreated", ascending: true)]
        observer.fetch(request: request)
        return observer
    }
}
