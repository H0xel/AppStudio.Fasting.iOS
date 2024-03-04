//  
//  SubscriptionServiceAdapterDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 25.01.2024.
//

import Dependencies
import AppStudioSubscriptions

extension DependencyValues {
    var subscriptionServiceAdapter: SubscriptionService {
        self[SubscriptionServiceAdapterKey.self]
    }
}

private enum SubscriptionServiceAdapterKey: DependencyKey {
    static var liveValue: SubscriptionService = SubscriptionServiceAdapterImpl()
    static var previewValue: SubscriptionService = SubscriptionServiceAdapterPreview()
}
