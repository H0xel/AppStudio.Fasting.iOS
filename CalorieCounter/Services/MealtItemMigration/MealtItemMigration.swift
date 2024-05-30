//
//  MealtItemMigrationServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.05.2024.
//

import Foundation
import Dependencies

class MealtItemMigration: Migration {

    @Dependency(\.mealService) private var mealService
    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService

    func migrate() async {
        guard let meals = try? await mealService.allMeals() else {
            return
        }
        for meal in meals {
            _ = try? await mealService.save(meal: meal)
            _ = try? await mealUsageService.incrementUsage(meal.mealItem, mealType: meal.type)
            await Task.yield()
        }
    }
}
