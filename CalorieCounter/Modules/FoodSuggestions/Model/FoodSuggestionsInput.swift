//
//  FoodSuggestionsInput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.07.2024.
//

import Foundation
import Combine

struct FoodSuggestionsInput {
    let mealPublisher: AnyPublisher<[MealItem], Never>
    let mealType: MealType
    let mealRequestPublisher: AnyPublisher<String, Never>
    let isPresented: Bool
    let collapsePublisher: AnyPublisher<Void, Never>
    let searchRequest: String
    let showOnlyIngredients: Bool
}
