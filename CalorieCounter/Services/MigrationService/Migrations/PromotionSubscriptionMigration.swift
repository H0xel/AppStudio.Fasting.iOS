//
//  PromotionSubscriptionMigration.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 17.06.2024.
//

import Dependencies
import MunicornFoundation

class PromotionSubscriptionMigration: Migration {
    @Dependency(\.newSubscriptionService) private var subscriptionService

    func migrate() async {
        await subscriptionService.restoreAppstoreTransactionsToSubs()
    }
}
