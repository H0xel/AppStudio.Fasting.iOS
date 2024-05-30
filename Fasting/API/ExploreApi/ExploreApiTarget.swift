//
//  ExploreApiTarget.swift
//  Fasting
//
//  Created by Denis Khlopin on 22.04.2024.
//

import Foundation
import Moya
import AICoach

private let basePath = "Fasting/Explore"

enum ExploreApiTarget {
    case files
    case download(file: String)
}

extension ExploreApiTarget: TelecomTargetType {
    var path: String {
        switch self {
        case .files:
            "\(basePath)"
        case .download:
            "\(basePath)/file"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        switch self {
        case .files:
            return .requestPlain
        case .download(let file):
            return .requestParameters(parameters: ["name": file], encoding: URLEncoding())
        }
    }
}
