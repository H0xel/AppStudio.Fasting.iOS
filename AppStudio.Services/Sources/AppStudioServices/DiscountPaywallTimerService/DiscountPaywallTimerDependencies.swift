//  
//  DiscountPaywallTimerDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 08.02.2024.
//

import Dependencies

public extension DependencyValues {
    var discountPaywallTimerService: DiscountPaywallTimerService {
        self[DiscountPaywallTimerServiceKey.self]
    }
}

private enum DiscountPaywallTimerServiceKey: DependencyKey {
    static var liveValue: DiscountPaywallTimerService = DiscountPaywallTimerServiceImpl()
}
