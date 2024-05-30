//
//  MealServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 22.12.2023.
//

import Foundation
import Dependencies

class MealServiceImpl: MealService {
    @Dependency(\.mealRepository) private var mealRepository
    @Dependency(\.mealItemService) private var mealItemService

    func save(meal: Meal) async throws -> Meal {
        if meal.isMealNeedToSave {
            _ = try await mealItemService.save(meal.mealItem)
        }
        return try await mealRepository.save(meal: meal)
    }

    func save(meals: [Meal]) async throws {
        for meal in meals {
            _ = try await save(meal: meal)
        }
    }

    func meals(forDay dayDate: Date, type: MealType?) async throws -> [Meal] {
        try await mealRepository.meals(forDay: dayDate, type: type)
    }

    func delete(byId id: String) async throws {
        try await mealRepository.delete(byId: id)
    }

    func mealObserver(dayDate: Date) -> MealObserver {
        mealRepository.mealObserver(dayDate: dayDate)
    }

    func allMeals() async throws -> [Meal] {
        try await mealRepository.allMeals()
    }
}
