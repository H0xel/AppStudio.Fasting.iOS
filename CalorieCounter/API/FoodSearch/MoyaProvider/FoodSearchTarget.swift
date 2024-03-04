//
//  FoodSearchTarget.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Foundation
import Moya
import Dependencies

private let obfuscatedKey = "385a0b1123040730751a6b6f1c3511236a6414652047290c1739361f251e2a403a2b4b153702021a"

enum FoodSearchTarget {
    case search(_ request: FoodSearchRequest)
}

extension FoodSearchTarget: FoodSearchTargetType {
    var path: String {
        "search"
    }

    var method: Moya.Method {
        switch self {
        case .search: .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .search(let request):
            @Dependency(\.obfuscator) var obfuscator
            let apiKey = obfuscator.reveal(key: obfuscatedKey)
            return .requestCompositeData(
                bodyData: request.jsonData() ?? Data(),
                urlParameters: ["api_key": apiKey]
            )
        }
    }
}
