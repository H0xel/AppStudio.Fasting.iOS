//  
//  MealUsageService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

protocol MealUsageService {
    func incrementUsage(_ mealItem: MealItem, mealType: MealType) async throws -> MealUsage
    func decrementUsage(_ mealItem: MealItem, mealType: MealType) async throws
    func favoriteMealItems(from mealItemIds: [String],
                           count: Int,
                           mealType: MealType) async throws -> [MealItem]
    func delete(byMealItemId id: String) async throws
}
