//
//  AIFoodSearchTarget.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.08.2024.
//

import Foundation
import Moya

enum AIFoodSearchTarget {
    case guess(foodDescription: String)
    case nutrients(query: String)
}

extension AIFoodSearchTarget: TelecomTargetType {
    var path: String {
        switch self {
        case .guess:
            "CalorieCounter/Nutrition/guess"
        case .nutrients:
            "CalorieCounter/Nutrition/search/nutrients"
        }
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case .guess(let foodDescription):
            .requestJSONEncodable(AIFoodSearchRequest(foodDescription: foodDescription))
        case .nutrients(let query):
            .requestJSONEncodable(AINutrientsSearchRequest(query: query))
        }
    }
}
