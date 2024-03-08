//
//  SubscriptionPreviewService.swift
//  Fasting
//
//  Created by Amakhin Ivan on 29.11.2023.
//

import AppStudioSubscriptions
import RxSwift
import Foundation

class PreviewSubscriptionService: SubscriptionService {
    var mayUseApp: RxSwift.Observable<Bool> { .just(false) }

    var canMakePayments: Bool { false }

    var firstPurchaseDate: Date?

    var actualSubscription: RxSwift.Observable<AppStudioSubscriptions.ActualSubscriptionType> {
        .just(.free)
    }

    var subscriptionProducts: RxSwift.Observable<[AppStudioSubscriptions.Subscription]> {
        .just([])
    }

    func purchase(subscription: AppStudioSubscriptions.Subscription, context: String) {}

    func restore() {}

    var allProducts: RxSwift.Observable<[AppStudioSubscriptions.Subscription]> {
        .just([])
    }

    func uploadReceipt() -> RxSwift.Observable<Void> {
        .just(())
    }

    func forceReload() -> RxSwift.Observable<Void> {
        .just(())
    }
}
