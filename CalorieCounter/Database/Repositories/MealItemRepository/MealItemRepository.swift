//  
//  MealItemRepositoryService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

protocol MealItemRepository {
    func mealItem(byId id: String) async throws -> MealItem?
    func mealItem(byBarcode barcode: String, type: MealCreationType) async throws -> MealItem?
    func mealItem(with name: String, type: MealCreationType) async throws -> MealItem?
    func sortedMealItems() async throws -> [MealItem]
    func save(_ mealItem: MealItem) async throws -> MealItem
    func delete(byId id: String) async throws
    func mealItemObserver() -> MealItemObserver
    func deleteAll() async throws
}
