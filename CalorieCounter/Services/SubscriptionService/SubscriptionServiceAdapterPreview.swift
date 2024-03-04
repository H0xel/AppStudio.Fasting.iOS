//
//  SubscriptionServiceAdapterPreview.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import Foundation
import Dependencies
import AppStudioSubscriptions
import RxSwift
import UIKit

import MunicornFoundation

class SubscriptionServiceAdapterPreview: SubscriptionService {

    var mayUseApp: RxSwift.Observable<Bool> {
        .just(true)
    }

    var canMakePayments: Bool {
        false
    }

    var firstPurchaseDate: Date? {
        nil
    }

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

