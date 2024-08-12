//
//  IngredientsMigration.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 24.07.2024.
//

import Foundation
import Dependencies

class IngredientsMigration: Migration {

    @Dependency(\.mealService) private var mealService
    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService

    func migrate() async {
        guard let meals = try? await mealService.allMeals() else {
            return
        }
        for meal in meals {
            let ingredients = meal.mealItem.ingredients
            for ingredient in ingredients {
                let mealItem = (try? await mealItemService
                    .mealItem(byName: ingredient.mealName, creationType: ingredient.type))
                ?? ingredient.withReplacedEmptyId
                _ = try? await mealItemService.save(mealItem)
                _ = try? await mealUsageService.incrementUsage(mealItem, mealType: meal.type)
                await Task.yield()
            }
        }
    }
}
