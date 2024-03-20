//  
//  SubscriptionsLoaderServiceImpl.swift
//  
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import AppStudioSubscriptions
import StoreKit
import Dependencies

class SubscriptionsLoaderServiceImpl: SubscriptionsLoaderService {
    @Dependency(\.subscriptionService) private var subscriptionService

    var subscriptions: [SKProduct] = []

    func initialize() {
        let skProducts = subscriptionService.allProducts.map { subscriptions in
            subscriptions.map { subscription in subscription.product }
        }

        Task {
            for try await skProducts in skProducts.values {
                subscriptions = skProducts
            }
        }
    }
}
