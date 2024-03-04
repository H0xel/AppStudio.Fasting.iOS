//
//  FoodSearchResponse.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

struct FoodSearchResponse: Codable {
    let totalHits: Int
    let currentPage: Int
    let totalPages: Int
    let pageList: [Int]
    let foodSearchCriteria: FoodSearchCriteria?
    let foods: [SearchResultFood]?
}
