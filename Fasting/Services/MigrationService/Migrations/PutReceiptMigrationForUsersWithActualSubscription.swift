//
//  PutReceiptMigrationForUsersWithActualSubscription.swift
//  Fasting
//
//  Created by Amakhin Ivan on 17.06.2024.
//

import Dependencies
import MunicornFoundation

class PutReceiptMigrationForUsersWithActualSubscription: Migration {
    @Dependency(\.newSubscriptionService) private var subscriptionService

    func migrate() async {
        await subscriptionService.restoreAppstoreTransactionsToSubs()
    }
}
