//
//  WeightGoalRepositoryImpl.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import MunicornCoreData
import Dependencies

class WeightGoalRepositoryImpl: CoreDataBaseRepository<WeightGoal>, WeightGoalRepository {
    
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func currentGoal() async throws -> WeightGoal? {
        let request = WeightGoal.request()
        request.fetchLimit = 1
        request.sortDescriptors = [.init(key: "dateCreated", ascending: false)]
        return try await select(request: request).first
    }

    func goals() async throws -> [WeightGoal] {
        let request = WeightGoal.request()
        request.sortDescriptors = [.init(key: "dateCreated", ascending: true)]
        return try await select(request: request)
    }
}
