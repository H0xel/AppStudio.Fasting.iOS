//
//  SubscriptionsTarget.swift
//  SecondPhone
//
//  Created by Konstantin Golenkov on 02.11.2023.
//

import Foundation
import Moya
import NewAppStudioSubscriptions

enum SubscriptionTarget {
    case getSubscription
    case putReceipt(PutReceiptRequest)
}

extension SubscriptionTarget: TelecomTargetType {

    var path: String {
        switch self {
        case .getSubscription:
            "account/subscription"
        case .putReceipt:
            "account/subscription/receipt"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getSubscription:
                .get
        case .putReceipt:
                .put
        }
    }

    var task: Moya.Task {
        switch self {
        case .getSubscription:
                .requestPlain
        case .putReceipt(let receiptReuest):
                .requestJSONEncodable(receiptReuest)
        }
    }
}
