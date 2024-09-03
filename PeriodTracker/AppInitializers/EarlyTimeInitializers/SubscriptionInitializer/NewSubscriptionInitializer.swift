//
//  NewSubscriptionInitializer.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.04.2024.
//

import Dependencies
import NewAppStudioSubscriptions
import AppStudioABTesting

final class NewSubscriptionInitializerService: AppInitializer {
    @Dependency(\.subscriptionInitializerService) private var subscriptionInitializerService
    @Dependency(\.subscriptionApi) private var subscriptionApi

    func initialize() {
        Task {
            do {
                // TODO: добавить ids для продуктов
                let ids: [String] = []
                try await subscriptionInitializerService.initialize(subscriptions: ids,
                                                                    apiService: subscriptionApi,
                                                                    timerMinuteInterval: nil)
            }
        }
    }
}
