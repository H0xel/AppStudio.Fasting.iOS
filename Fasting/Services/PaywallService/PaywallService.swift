//
//  PaywallService.swift
//  Fasting
//
//  Created by Denis Khlopin on 18.10.2023.
//

import AppStudioNavigation

public protocol PaywallService {
    func hasSubscription() async -> Bool
    func presentPaywallIfNeeded(paywallContext: PaywallServiceContext, router: Router) async -> Bool
}
