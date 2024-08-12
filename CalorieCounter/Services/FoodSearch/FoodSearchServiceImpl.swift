//  
//  FoodSearchServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//
import Dependencies
import Foundation

private let proteinNutrientId: Int = 1003
private let carboNutrientIdId: Int = 1005
private let fatNutrientIdId: Int = 1004
private let caloriesNutrientId: Int = 1008

class FoodSearchServiceImpl: FoodSearchService {
    @Dependency(\.foodSearchApi) private var foodSearchApi
    @Dependency(\.nutritionFoodSearchApi) private var nutritionFoodSearchApi
    @Dependency(\.foodSearchCacheService) private var foodSearchCacheService
    @Dependency(\.mealItemService) private var mealItemService

    func search(barcode: String) async throws -> MealItem? {
        guard let code = Int64(barcode) else {
            return nil
        }

        if let meal = try await mealItemService.mealItem(byBarcode: barcode) {
            return meal
        }

        if let meal = try await foodSearchCacheService.cachedFood(of: barcode) {
            return meal
        }

        do {
            guard let apiMeal = try await nutritionFoodSearchApi.search(code: code).asMeal else {
                return nil
            }

            try await foodSearchCacheService.cache(meal: apiMeal, for: barcode)
            return apiMeal
        } catch {
            try await Task.sleep(seconds: 2)
            return nil
        }
    }

    func searchIngredient(barcode: String) async throws -> MealItem? {
        guard let code = Int64(barcode) else {
            return nil
        }
        if let ingredient = try await foodSearchCacheService.cachedIngredient(of: barcode) {
            return ingredient
        }
        guard let apiIngredient = try await nutritionFoodSearchApi.search(code: code).asIngredientMealItem else {
            return nil
        }
        try await foodSearchCacheService.cache(ingredient: apiIngredient, for: barcode)
        return apiIngredient
    }

    func searchText(query: String) async throws -> [MealItem] {
        guard query.count >= 3 else {
            return []
        }
        if let foods = try await foodSearchCacheService.cachedFoods(of: query) {
            let updated = try await updateBrandedTypes(of: foods)
            if updated.isUpdated {
                try await foodSearchCacheService.cache(foods: updated.items, for: query)
            }
            return updated.items
        }
        let meals = try await nutritionFoodSearchApi.search(query: query).compactMap { $0.asIngredientMealItem }

        let updated = try await updateBrandedTypes(of: meals)

        try await foodSearchCacheService.cache(foods: updated.items, for: query)

        return updated.items
    }

    func searchBranded(brandFoodId: String) async throws -> MealItem? {
        guard !brandFoodId.isEmpty else {
            return nil
        }

        if let cached = try await foodSearchCacheService.cachedBrandFood(of: brandFoodId) {
            return cached
        }
        
        if let brandFood = try await nutritionFoodSearchApi.search(brandFoodId: brandFoodId).asIngredientMealItem {
            try await foodSearchCacheService.cache(brandFood: brandFood, for: brandFoodId)

            return brandFood
        }
        return nil
    }

    func updateBrandedTypes(of meals: [MealItem]) async throws -> (items: [MealItem], isUpdated: Bool) {
        var updated = [MealItem]()
        var isUpdated = false
        for meal in meals {
            if let brandFoodId = meal.brandFoodId {
                if let brandedMeal = try await foodSearchCacheService.cachedBrandFood(of: brandFoodId) {
                    updated.append(brandedMeal)
                    isUpdated = true
                    continue
                }
                updated.append(meal.updated(type: .needToUpdateBrand))
                continue
            }
            updated.append(meal)
        }

        return (items: updated, isUpdated: isUpdated)
    }
}

private extension FoodSearchResponse {
    func asMeal(fdcId: String) -> MealItem? {

        guard let foods else {
            return nil
        }

        guard let food = foods.first(where: { $0.fdcId == Int(fdcId) }) ?? foods.first else {
            return nil
        }

        let name = food.description.capitalized
        let brandName = (food.brandName ?? food.brandOwner)?.capitalized

        guard let nutriens = food.foodNutrients else {
            return nil
        }

        let protein = nutriens.first { $0.nutrientId == proteinNutrientId }?.value ?? 0.0
        let carbo = nutriens.first { $0.nutrientId == carboNutrientIdId }?.value ?? 0.0
        let fat = nutriens.first { $0.nutrientId == fatNutrientIdId }?.value ?? 0.0
        let calories = nutriens.first { $0.nutrientId == caloriesNutrientId }?.value ?? 0.0

        // TODO: тут могут быть ml или g, надо будет обработать в будующем
        let weight = food.servingSize ?? 0

        return MealItem(
            id: UUID().uuidString,
            type: .chatGPT,
            name: "",
            subTitle: nil,
            notes: nil,
            ingredients: [
                .createIngredient(
                    name: name,
                    brand: brandName,
                    weight: Double(weight),
                    normalizedProfile: .init(
                        calories: calories,
                        proteins: protein,
                        fats: fat,
                        carbohydrates: carbo)
                )
            ],
            servingMultiplier: 1.0,
            servings: .defaultServings
        )
    }

    func asIngredient(fdcId: String) -> MealItem? {

        guard let foods else {
            return nil
        }

        guard let food = foods.first(where: { $0.fdcId == Int(fdcId) }) ?? foods.first else {
            return nil
        }

        let name = food.description.capitalized
        let brandName = (food.brandName ?? food.brandOwner)?.capitalized

        guard let nutriens = food.foodNutrients else {
            return nil
        }

        let protein = nutriens.first { $0.nutrientId == proteinNutrientId }?.value ?? 0.0
        let carbo = nutriens.first { $0.nutrientId == carboNutrientIdId }?.value ?? 0.0
        let fat = nutriens.first { $0.nutrientId == fatNutrientIdId }?.value ?? 0.0
        let calories = nutriens.first { $0.nutrientId == caloriesNutrientId }?.value ?? 0.0

        // TODO: тут могут быть ml или g, надо будет обработать в будующем
        let weight = food.servingSize ?? 0

        return MealItem.createIngredient(
            name: name,
            brand: brandName,
            weight: Double(weight),
            normalizedProfile: .init(
                calories: calories,
                proteins: protein,
                fats: fat,
                carbohydrates: carbo
            )
        )
    }
}
