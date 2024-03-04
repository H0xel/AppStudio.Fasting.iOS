//  
//  SubscriptionServiceAdapterServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 25.01.2024.
//

import Foundation
import Dependencies
import AppStudioSubscriptions
import RxSwift
import UIKit

import MunicornFoundation

class SubscriptionServiceAdapterImpl: SubscriptionService {
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.storageService) private var storageService

    var mayUseApp: RxSwift.Observable<Bool> {
        if UIDevice.current.isSandbox {
            return storageService.isSubscriptionEnabled ? .just(true) : subscriptionService.mayUseApp
        }
        return subscriptionService.mayUseApp
    }

    var canMakePayments: Bool {
        if UIDevice.current.isSandbox {
            return storageService.isSubscriptionEnabled ? true : subscriptionService.canMakePayments
        }
        return subscriptionService.canMakePayments
    }

    var firstPurchaseDate: Date? {
        if UIDevice.current.isSandbox {
            return storageService.isSubscriptionEnabled ? .now : subscriptionService.firstPurchaseDate
        }
        return subscriptionService.firstPurchaseDate
    }

    var actualSubscription: RxSwift.Observable<AppStudioSubscriptions.ActualSubscriptionType> {
        if UIDevice.current.isSandbox {
            return storageService.isSubscriptionEnabled
            ? .just(.unlimited(renewDate: .now.addingTimeInterval(.day), duration: .month, productId: ""))
            : subscriptionService.actualSubscription
        }
        return subscriptionService.actualSubscription
    }

    var subscriptionProducts: RxSwift.Observable<[AppStudioSubscriptions.Subscription]> {
        subscriptionService.subscriptionProducts
    }

    func purchase(subscription: AppStudioSubscriptions.Subscription, context: String) {
        subscriptionService.purchase(subscription: subscription, context: context)
    }

    func restore() {
        subscriptionService.restore()
    }
    
    var allProducts: RxSwift.Observable<[AppStudioSubscriptions.Subscription]> {
        subscriptionService.allProducts
    }

    func uploadReceipt() -> RxSwift.Observable<Void> {
        subscriptionService.uploadReceipt()
    }

    func forceReload() -> RxSwift.Observable<Void> {
        subscriptionService.forceReload()
    }
}
