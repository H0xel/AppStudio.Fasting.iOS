//
//  MealRepository.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 21.12.2023.
//

import Foundation
import MunicornCoreData

protocol MealRepository {
    func save(meal: Meal) async throws -> Meal
    func meals(forDay dayDate: Date, type: MealType?) async throws -> [Meal]
    func delete(byId id: String) async throws
    func mealObserver(dayDate: Date) -> MealObserver
}
