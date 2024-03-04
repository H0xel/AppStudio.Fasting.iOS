//
//  FoodSearchTargetType.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation
import Moya
import Dependencies

private let baseUrl = "https://api.nal.usda.gov/fdc/v1/foods/"

protocol FoodSearchTargetType: TargetType {}

extension FoodSearchTargetType {

    var baseURL: URL {
        guard let url = URL(string: baseUrl) else {
            fatalError("Base URL is not configured")
        }
        return url
    }

    var headers: [String: String]? {
        [
            "accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}
