//  
//  PromoPaywallDependencies.swift
//  Fasting
//
//  Created by Amakhin Ivan on 13.02.2024.
//

import Dependencies

extension DependencyValues {
    var promoPaywallService: PromoPaywallService {
        self[PromoPaywallServiceKey.self]
    }
}

private enum PromoPaywallServiceKey: DependencyKey {
    static var liveValue: PromoPaywallService = PromoPaywallServiceImpl()
}
