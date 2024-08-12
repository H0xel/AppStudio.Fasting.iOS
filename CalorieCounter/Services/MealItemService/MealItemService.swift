//  
//  MealItemService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

protocol MealItemService {
    func save(_ mealItem: MealItem) async throws -> MealItem
    func sortedMealItems() async throws -> [MealItem]
    func mealItem(byName name: String, creationType: MealCreationType) async throws -> MealItem?
    func mealItem(byId id: String) async throws -> MealItem?
    func mealItem(byBarcode barcode: String) async throws -> MealItem? 
    func delete(byId id: String) async throws
    func mealItemObserver() -> MealItemObserver
    func update(mealItem: MealItem) async throws -> MealItem
}
