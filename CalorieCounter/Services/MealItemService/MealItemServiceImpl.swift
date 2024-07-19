//  
//  MealItemServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies

class MealItemServiceImpl: MealItemService {

    @Dependency(\.mealItemRepository) private var mealItemRepository

    func sortedMealItems() async throws -> [MealItem] {
        try await mealItemRepository.sortedMealItems()
    }

    func mealItem(byName name: String, creationType: MealCreationType) async throws -> MealItem? {
        try await mealItemRepository.mealItem(with: name, type: creationType)
    }

    func mealItem(byId id: String) async throws -> MealItem? {
        try await mealItemRepository.mealItem(byId: id)
    }

    func save(_ mealItem: MealItem) async throws -> MealItem {
        if let meal = try await mealItemRepository.mealItem(with: mealItem.mealName, type: mealItem.type) {
            return try await mealItemRepository.save(meal.updated(ingredients: mealItem.ingredients))
        }
        return try await mealItemRepository.save(mealItem.updated(name: mealItem.mealName))
    }

    func delete(byId id: String) async throws {
        try await mealItemRepository.delete(byId: id)
    }
}
