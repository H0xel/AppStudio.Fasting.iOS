//
//  SearchResultFood.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

struct SearchResultFood: Codable {
    let fdcId: Int
    let description: String

    let dataType: String?
    let foodCode: String?

    let gtinUpc: String?
    let publishedDate: String?
    let brandOwner: String?
    let brandName: String?
    let ingredients: String?
    let marketCountry: String?
    let foodCategory: String?
    let modifiedDate: String?
    let dataSource: String?
    let packageWeight: String?
    let servingSizeUnit: String?
    let servingSize: Int?
    let tradeChannels: [FoodSearchTradeChannel]?
    let allHighlightFields: String?
    let score: Double?
    let microbes: [String]?
    let foodNutrients: [FoodNutrient]?
}
