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

    func update(mealItem: MealItem) async throws -> MealItem {
        try await mealItemRepository.save(mealItem)
    }

    func mealItem(byId id: String) async throws -> MealItem? {
        try await mealItemRepository.mealItem(byId: id)
    }

    func mealItem(byBarcode barcode: String) async throws -> MealItem? {
        try await mealItemRepository.mealItem(byBarcode: barcode, type: .product)
    }

    func save(_ mealItem: MealItem) async throws -> MealItem {
        if mealItem.ingredients.count > 1 {
            for ingredient in mealItem.ingredients.reversed() {
                _ = try await save(ingredient.mealItem)
            }
        }
        if let barcode = mealItem.barCode,
           let meal = try await mealItemRepository.mealItem(byBarcode: barcode, type: .product) {
            return try await saveMealItem(current: meal, updated: mealItem)
        }
        if let meal = try await mealItemRepository.mealItem(with: mealItem.mealName, type: mealItem.type) {
            return try await saveMealItem(current: meal, updated: mealItem)
        }
        return try await mealItemRepository.save(mealItem.updated(name: mealItem.mealName, forceDateUpdated: .now))
    }

    func forceSave(_ mealItem: MealItem) async throws -> MealItem {
        try await mealItemRepository.save(mealItem)
    }

    func delete(byId id: String) async throws {
        try await mealItemRepository.delete(byId: id)
    }

    func mealItemObserver() -> MealItemObserver {
        mealItemRepository.mealItemObserver()
    }

    private func saveMealItem(current: MealItem, updated: MealItem) async throws -> MealItem {
        let updatedIngredients = updated.ingredients.map {
            $0.updated(servingMultiplier: $0.servingMultiplier / updated.servingMultiplier)
        }
        let updatedMeal = current.updated(ingredients: updatedIngredients)
        return try await mealItemRepository.save(updatedMeal)
    }

    func deleteAll() async throws {
        try await mealItemRepository.deleteAll()
    }
}
