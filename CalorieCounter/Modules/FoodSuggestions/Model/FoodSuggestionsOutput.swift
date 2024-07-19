//
//  FoodSuggestionsOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.07.2024.
//

import Foundation

enum FoodSuggestionsOutput {
    case add(MealItem)
    case remove(MealItem)
    case togglePresented(isPresented: Bool)
}
