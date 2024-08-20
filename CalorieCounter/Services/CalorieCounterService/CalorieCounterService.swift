//  
//  CalorieCounterService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

protocol CalorieCounterService {
    func food(request: String) async throws -> [MealItem]
    func ingredients(request: String) async throws -> [IngredientStruct]
}
