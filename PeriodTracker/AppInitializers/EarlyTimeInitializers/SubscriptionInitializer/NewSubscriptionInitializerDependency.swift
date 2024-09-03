//
//  NewSubscriptionInitializerDependency.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.05.2024.
//

import Dependencies

extension DependencyValues {
    var newSubscriptionInitializer: AppInitializer {
        self[NewSubscriptionInitializerKey.self]
    }
}

private enum NewSubscriptionInitializerKey: DependencyKey {
    static let liveValue: AppInitializer = NewSubscriptionInitializerService()
}
