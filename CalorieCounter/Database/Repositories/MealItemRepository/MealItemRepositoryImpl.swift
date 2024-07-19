//  
//  MealItemRepositoryServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import MunicornCoreData
import Dependencies

class MealItemRepositoryImpl: CoreDataBaseRepository<MealItem>, MealItemRepository {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func mealItem(with name: String, type: MealCreationType) async throws -> MealItem? {
        let request = MealItem.request()
        request.predicate = .init(format: "name = %@ AND creationType = %i", name, type.rawValue)
        request.fetchLimit = 1
        return try await select(request: request).first
    }

    func mealItem(byId id: String) async throws -> MealItem? {
        try await object(byId: id)
    }

    func sortedMealItems() async throws -> [MealItem] {
        let request = MealItem.request()
        request.sortDescriptors = [.init(key: "dateUpdated", ascending: false)]
        return try await select(request: request)
    }
}
