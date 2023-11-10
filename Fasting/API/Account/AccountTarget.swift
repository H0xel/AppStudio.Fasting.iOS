//
//  AccountTarget.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation
import Moya

enum AccountTarget {
    case getAccount
    case putAccount(PutAccountRequest)
    case putPushToken(PutPushTokenRequest)
}

extension AccountTarget: TelecomTargetType {

    var path: String {
        "account"
    }

    var method: Moya.Method {
        switch self {
        case .getAccount:
                .get
        case .putAccount, .putPushToken:
                .put
        }
    }

    var task: Moya.Task {
        switch self {
        case .getAccount:
                .requestPlain
        case .putAccount(let account):
                .requestJSONEncodable(account)
        case .putPushToken(let token):
                .requestJSONEncodable(token)
        }
    }
}
