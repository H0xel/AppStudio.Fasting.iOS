//
//  FoodSearchTradeChannel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

enum FoodSearchTradeChannel: String, Codable {
    case noChannel = "NO_TRADE_CHANNEL"
    case childNutritionFoodPrograms = "CHILD_NUTRITION_FOOD_PROGRAMS"
    case drug = "DRUG"
    case foodService = "FOOD_SERVICE"
    case grocery = "GROCERY"
    case massMerchandising = "MASS_MERCHANDISING"
    case military = "MILITARY"
    case online = "ONLINE"
    case vending = "VENDING"
}
