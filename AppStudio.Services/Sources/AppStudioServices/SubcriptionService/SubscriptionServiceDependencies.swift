//
//  SubscriptionServiceDependencies.swift
//
//
//  Created by Amakhin Ivan on 11.03.2024.
//

import AppStudioSubscriptions
import Dependencies

public extension DependencyValues {
    var subscriptionService: SubscriptionService {
        guard let subscriptionService = self[SubscriptionServiceKey.self] else {
            fatalError("subscriptionService dependency is not registred!")
        }
        return subscriptionService
    }
}

public enum SubscriptionServiceKey: DependencyKey {
    public static var liveValue: SubscriptionService?
    public static var previewValue: SubscriptionService? = PreviewSubscriptionService()
}
