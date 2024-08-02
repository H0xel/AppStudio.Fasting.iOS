//
//  PutReceiptMigrationForUsersWithActualSubscription.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 31.07.2024.
//

import Dependencies
import MunicornFoundation

class PutReceiptMigrationForUsersWithActualSubscription: Migration {
    @Dependency(\.newSubscriptionService) private var subscriptionService

    func migrate() async {
        await subscriptionService.restoreAppstoreTransactionsToSubs()
    }
}
