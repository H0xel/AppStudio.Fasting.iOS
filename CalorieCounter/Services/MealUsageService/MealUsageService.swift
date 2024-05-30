//  
//  MealUsageService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

protocol MealUsageService {
    func sortedUsage(count: Int, mealType: MealType) async throws -> [MealUsage]
    func incrementUsage(_ mealItem: MealItem, mealType: MealType) async throws -> MealUsage
    func decrementUsage(_ mealItem: MealItem, mealType: MealType) async throws
    func favoriteMealItems(count: Int, mealType: MealType) async throws -> [MealItem]
}
