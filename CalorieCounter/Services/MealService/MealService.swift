//
//  MealService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 22.12.2023.
//

import Foundation

protocol MealService {
    func save(meal: Meal) async throws -> Meal
    func save(meals: [Meal]) async throws
    func meals(forDay dayDate: Date, type: MealType?) async throws -> [Meal]
    func delete(byId id: String) async throws
    func mealObserver(dayDate: Date) -> MealObserver
    func allMeals() async throws -> [Meal]
    func saveWithoutMealItem(meal: Meal) async throws -> Meal
}
