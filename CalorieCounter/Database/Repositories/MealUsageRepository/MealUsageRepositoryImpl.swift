//  
//  MealUsageRepositoryServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies
import MunicornCoreData

class MealUsageRepositoryImpl: CoreDataBaseRepository<MealUsage>, MealUsageRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func usage(byMealId id: String) async throws -> [MealUsage] {
        let request = MealUsage.request()
        request.predicate = .init(format: "mealId = %@", id)
        return try await select(request: request)
    }

    func usage(byMealId id: String, type: MealType) async throws -> MealUsage? {
        let request = MealUsage.request()
        request.predicate = .init(format: "mealId = %@ AND mealType = %@", id, type.rawValue)
        request.fetchLimit = 1
        return try await select(request: request).first
    }

    func sortedUsage(count: Int, mealType: MealType) async throws -> [MealUsage] {
        let request = MealUsage.request()
        request.fetchLimit = count
        request.predicate = .init(format: "mealType = %@", mealType.rawValue)
        request.sortDescriptors = [.init(key: "usage", ascending: false)]
        return try await select(request: request)
    }
}
