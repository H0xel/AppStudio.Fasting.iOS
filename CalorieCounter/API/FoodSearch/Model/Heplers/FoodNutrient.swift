//
//  FoodNutrient.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

struct FoodNutrient: Codable {
    let nutrientId: Int
    let nutrientName: String?
    let nutrientNumber: String
    let unitName: String
    let derivationCode: String?
    let derivationDescription: String?
    let derivationId: Int?
    let value: Double?
    let foodNutrientSourceId: Int?
    let foodNutrientSourceCode: String
    let foodNutrientSourceDescription: String?
    let rank: Int?
    let indentLevel: Int?
    let foodNutrientId: Int?
    let percentDailyValue: Int?
}
