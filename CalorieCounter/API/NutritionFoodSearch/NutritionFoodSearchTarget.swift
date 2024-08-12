//
//  NutritionFoodSearchTarget.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

import Foundation
import Moya

enum NutritionFoodSearchTarget {
    case searchBarcode(upc: Int64)
    case searchText(query: String)
    case searchBrand(brandFoodId: String)
}

extension NutritionFoodSearchTarget: TelecomTargetType {
    var path: String {
        switch self {
        case .searchBarcode(let upc):
            "CalorieCounter/Nutrition/search/upc/\(upc)"
        case .searchText(let query):
            "CalorieCounter/Nutrition/search/full-text/\(query)"
        case .searchBrand(let brandFoodId):
            "CalorieCounter/Nutrition/search/branded/\(brandFoodId)"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        Moya.Task.requestPlain
    }
}
