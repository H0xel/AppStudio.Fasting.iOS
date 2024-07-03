//
//  NutritionFoodSearchTarget.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

import Foundation
import Moya

enum NutritionFoodSearchTarget {
    case search(upc: Int64)
}

extension NutritionFoodSearchTarget: TelecomTargetType {
    var path: String {
        switch self {
        case .search(let upc):
            "CalorieCounter/Nutrition/search/upc/\(upc)"
        }

    }

    var method: Moya.Method {
        switch self {
        case .search:
                .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .search:
            Moya.Task.requestPlain
        }
    }
}
