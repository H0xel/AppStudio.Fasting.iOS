//  
//  FoodSearchService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

protocol FoodSearchService {
    func search(barcode: String) async throws -> MealItem?
    func searchIngredient(barcode: String) async throws -> Ingredient?
}