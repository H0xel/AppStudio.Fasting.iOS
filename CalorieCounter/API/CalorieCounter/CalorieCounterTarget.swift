//
//  CalorieCounterTarget.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation
import Moya

enum CalorieCounterTarget {
    case calculate(CaloriesCalculateRequest)
}

extension CalorieCounterTarget: TelecomTargetType {
    var path: String {
        "CalorieCounter"
    }

    var method: Moya.Method {
        switch self {
        case .calculate:
                .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .calculate(let request):
                .requestJSONEncodable(request)
        }
    }
}
