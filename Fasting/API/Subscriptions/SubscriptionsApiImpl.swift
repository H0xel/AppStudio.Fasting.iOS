//
//  SubscriptionsApiImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation
import Moya
import AppStudioSubscriptions
import MunicornAPI
import Dependencies
import MunicornUtilities

final class SubscriptionsApiImpl: SubscriptionApi {

    private let provider = TelecomApiProvider<SubscriptionTarget>()

    func subscription(forceUpdate: Bool,
                      completion: @escaping CompletionCallback<AppStudioSubscriptions.ApiSubscription>) {

        _Concurrency.Task {
            do {
                let subscription: ApiSubscription = try await provider.request(.getSubscription)
                completion(.success(subscription))
            } catch {
                // TODO: better map error
                completion(.failure(resultCode: "unknown",
                                    title: "Parsing error",
                                    userMessage: error.localizedDescription,
                                    versionInfo: nil))
            }
        }
    }

    func set(receipt: String,
             transactions: [AppStudioSubscriptions.TransactionInfo],
             context: String?,
             completion: @escaping CompletionCallback<AppStudioSubscriptions.ApiSubscription>) {

        _Concurrency.Task {
            let putReceiptRequest = PutReceiptRequest(receiptData: receipt,
                                                      transactions: transactions,
                                                      context: context)
            do {
                let subscription: ApiSubscription = try await provider.request(.putReceipt(putReceiptRequest))
                completion(.success(subscription))
            } catch {
                // TODO: better map error
                completion(.failure(resultCode: "unknown",
                                    title: "Parsing error",
                                    userMessage: error.localizedDescription,
                                    versionInfo: nil))
            }
        }
    }
}
