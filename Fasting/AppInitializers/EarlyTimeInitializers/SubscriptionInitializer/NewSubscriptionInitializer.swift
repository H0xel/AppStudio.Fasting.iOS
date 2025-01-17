//
//  NewSubscriptionInitializer.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.04.2024.
//

import Dependencies
import NewAppStudioSubscriptions
import AppStudioABTesting
import AppStudioServices

final class NewSubscriptionInitializerService: AppInitializer {
    @Dependency(\.subscriptionInitializerService) private var subscriptionInitializerService
    @Dependency(\.subscriptionApi) private var subscriptionApi
    @Dependency(\.productIdsLoaderService) private var productIdsLoaderService

    func initialize() {
        Task {
            do {
                let ids = productIdsLoaderService.productsIds(ids: .fasting)
                try await subscriptionInitializerService.initialize(subscriptions: ids,
                                                                    apiService: subscriptionApi,
                                                                    timerMinuteInterval: nil)
            }
        }
    }
}
