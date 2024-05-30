//  
//  MealUsageRepositoryService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

protocol MealUsageRepository {
    func usage(byMealId id: String) async throws -> [MealUsage]
    func usage(byMealId id: String, type: MealType) async throws -> MealUsage?
    func sortedUsage(count: Int, mealType: MealType) async throws -> [MealUsage]
    func save(_ mealUsage: MealUsage) async throws -> MealUsage
    func delete(byId id: String) async throws
}
