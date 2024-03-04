//
//  FoodSearchRequest.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation

struct FoodSearchRequest: Codable {
    let query: String
    let dataType: [FoodSearchDataType]?
    let pageSize: Int?
    let pageNumber: Int?
    let sortBy: FoodSearchSortType?
    let sortOrder: FoodSearchSortOrder?
    let brandOwner: String?
    let tradeChannel: [FoodSearchTradeChannel]?
    let startDate: String?
    let endDate: String?

    init(
        query: String,
        dataType: [FoodSearchDataType]? = nil,
        pageSize: Int? = nil,
        pageNumber: Int? = nil,
        sortBy: FoodSearchSortType? = nil,
        sortOrder: FoodSearchSortOrder? = nil,
        brandOwner: String? = nil,
        tradeChannel: [FoodSearchTradeChannel]? = nil,
        startDate: String? = nil,
        endDate: String? = nil
    ) {

        self.query = query
        self.dataType = dataType
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.sortBy = sortBy
        self.sortOrder = sortOrder
        self.brandOwner = brandOwner
        self.tradeChannel = tradeChannel
        self.startDate = startDate
        self.endDate = endDate
    }
}
