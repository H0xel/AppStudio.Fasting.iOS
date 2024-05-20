//
//  SubscriptionsApiImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation
import Moya
import NewAppStudioSubscriptions
import MunicornAPI
import Dependencies
import MunicornUtilities

final class SubscriptionsApiImpl: SubscriptionApi {

    private let provider = TelecomApiProvider<SubscriptionTarget>()

    func subscription() async throws -> ApiSubscription {
        try await provider.request(.getSubscription)
    }

    func set(iosJwsToken: String, context: String?) async throws -> ApiSubscription {
        let putReceiptRequest = PutReceiptRequest(iosJwsToken: iosJwsToken,
                                                  context: context)
        return try await provider.request(.putReceipt(putReceiptRequest))
    }
}
