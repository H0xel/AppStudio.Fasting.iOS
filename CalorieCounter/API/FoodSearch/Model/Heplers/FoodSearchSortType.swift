//
//  FoodSearchSortType.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

enum FoodSearchSortType: String, Codable {
    case dataTypeKeyword = "dataType.keyword"
    case lowercaseDescriptionKeyword = "lowercaseDescription.keyword"
    case fdcId = "fdcId"
    case publishedDate = "publishedDate"
}
