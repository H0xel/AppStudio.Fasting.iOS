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
    @Dependency(\.foodSearchCacheService) private var foodSearchCacheService

    func search(barcode: String) async throws -> MealItem? {
        if let meal = try await foodSearchCacheService.cachedFood(of: barcode) {
            return meal
        }
        guard let apiMeal = try await foodSearchApi.search(FoodSearchRequest(query: barcode))
            .asMeal(fdcId: barcode) else {
            return nil
        }
        try await foodSearchCacheService.cache(meal: apiMeal, for: barcode)
        return apiMeal
    }

    func searchIngredient(barcode: String) async throws -> Ingredient? {
        if let ingredient = try await foodSearchCacheService.cachedIngredient(of: barcode) {
            return ingredient
        }
        guard let apiIngredient = try await foodSearchApi.search(FoodSearchRequest(query: barcode))
            .asIngredient(fdcId: barcode) else {
            return nil
        }
        try await foodSearchCacheService.cache(ingredient: apiIngredient, for: barcode)
        return apiIngredient
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
            name: "",
            subTitle: nil,
            ingredients: [
                Ingredient(
                    name: name,
                    brandTitle: brandName,
                    weight: Double(weight),
                    normalizedProfile: NutritionProfile(
                        calories: calories,
                        proteins: protein,
                        fats: fat,
                        carbohydrates: carbo
                    )
                )
            ], 
            creationType: .chatGPT,
            dateUpdated: .now
        )
    }

    func asIngredient(fdcId: String) -> Ingredient? {

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

        return Ingredient(
            name: name,
            brandTitle: brandName,
            weight: Double(weight),
            normalizedProfile: NutritionProfile(
                calories: calories,
                proteins: protein,
                fats: fat,
                carbohydrates: carbo
            )
        )
    }
}
