//
//  CodableCache.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.01.2024.
//

import Foundation

struct CodableCache {
    let id: String
    let key: String
    let type: CodableCacheType
    let date: Date
    let value: String

    init(id: String? = nil, key: String, type: CodableCacheType, date: Date, value: String) {
        self.id = id ?? UUID().uuidString
        self.key = key
        self.type = type
        self.date = date
        self.value = value
    }
}

enum CodableCacheType: Int16 {
    case `default`
    case foodSearch
    case calorieCounter
    case ingredients
    case foodSearchIngredient
    case foodsTextSearch
    case brandedFood
    case aiFood
    case aiNutrients
}
