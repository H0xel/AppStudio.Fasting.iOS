//
//  MealServicePreview.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import Foundation
import Dependencies

class MealServicePreview: MealService {
    func deleteAll() async throws {}

    func saveWithoutMealItem(meal: Meal) async throws -> Meal {
        .mock
    }
    
    func allMeals() async throws -> [Meal] {
        [.mock, .mock, .mock]
    }

    func save(meal: Meal) async throws -> Meal {
        .init(type: .breakfast, dayDate: .now, mealItem: .mock, voting: .disabled)
    }

    func save(meals: [Meal]) async throws {}

    func meals(forDay dayDate: Date, type: MealType?) async throws -> [Meal] {
        [.init(type: .breakfast, dayDate: .now, mealItem: .mock, voting: .disabled)]
    }

    func delete(byId id: String) async throws {}

    func meals(for dates: [Date]) async throws -> [Meal] {
        [.init(type: .breakfast, dayDate: .now, mealItem: .mock, voting: .disabled)]
    }

    func mealObserver(dayDate: Date) -> MealObserver {
        @Dependency(\.coreDataService) var coreDataService
        return .init(coreDataService: coreDataService)
    }
}
