//
//  SubscriptionDependencies.swift
//  AppStudio
//
//  Created by Denis Khlopin on 04.08.2023.
//

import Dependencies
import AppStudioFoundation
import AppStudioSubscriptions

extension DependencyValues {
    var subscriptionService: SubscriptionService {
        guard let subscriptionService = self[SubscriptionServiceKey.self] else {
            fatalError("subscriptionService dependency is not registred!")
        }
        return subscriptionService
    }

    var appStudioSubscriptionDelegate: AppStudioSubscriptionDelegate {
        self[AppStudioSubscriptionDelegateKey.self]
    }

    var productProvider: ProductProvider {
        self[ProductProviderKey.self]
    }

    var paywallService: PaywallService {
        self[PaywallServiceAndInitializerKey.self]
    }

    var paywallServiceInitializer: AppInitializer {
        self[PaywallServiceAndInitializerKey.self]
    }
}

private enum PaywallServiceAndInitializerKey: DependencyKey {
    static var liveValue = PaywallServiceImpl()
}

enum SubscriptionServiceKey: DependencyKey {
    static var liveValue: SubscriptionService?
}

private enum AppStudioSubscriptionDelegateKey: DependencyKey {
    static var liveValue: AppStudioSubscriptionDelegate = SubscriptionDelegateImpl()
}

private enum ProductProviderKey: DependencyKey {
    static var liveValue: ProductProvider = ProductProviderImpl()
}
