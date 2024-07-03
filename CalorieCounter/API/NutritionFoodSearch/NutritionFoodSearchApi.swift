//  
//  NutritionFoodSearchApi.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

protocol NutritionFoodSearchApi {
    func search(code: Int64) async throws -> NutritionFood
}
