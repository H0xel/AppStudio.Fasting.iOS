//
//  CoachApiTarget.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.04.2024.
//

import Foundation
import Moya
import AICoach

private let basePath = "Fasting/Coach/"

enum CoachApiTarget {
    case sendMessage(request: SendMessageRequest)
    case messages(request: CoachMessagesRequest)
    case runStatus(runId: String)
}

extension CoachApiTarget: TelecomTargetType {
    var path: String {
        switch self {
        case .sendMessage, .messages:
            "\(basePath)messages"
        case .runStatus(let runId):
            "\(basePath)runs/\(runId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sendMessage:
                .post
        case .messages, .runStatus:
                .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .sendMessage(let request):
            return .requestJSONEncodable(request)
        case .messages(request: let request):
            return .requestParameters(parameters: ["After": request.after, "Limit": request.limit],
                                      encoding: URLEncoding())
        case .runStatus:
            return .requestPlain
        }
    }
}
