//
//  FoodSearchCriteria.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

struct FoodSearchCriteria: Codable {
    let query: String
    let dataType: FoodSearchDataType?
    let pageSize: Int?
    let pageNumber: Int?
    let sortBy: FoodSearchSortType?
    let sortOrder: FoodSearchSortOrder?
    let brandOwner: String?
    let tradeChannel: [FoodSearchTradeChannel]?
    let startDate: String?
    let endDate: String?

    let generalSearchInput: String?
    let numberOfResultsPerPage: Int?
    let requireAllWords: Bool?
}
