//
//  AppCustomizationPreview.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 15.02.2024.
//


import Foundation
import RxRelay
import RxSwift

class AppCustomizationPreview: AppCustomization, ProductIdsService {
    func resetDiscountExp() {
    }
    
    func exp() async throws -> String {
        ""
    }
    
    var discountPaywallExperiment: RxSwift.Observable<DiscountPaywallInfo> {
        .just(.empty)
    }

    func shouldForceUpdate() async throws -> Bool {
        return false
    }
    
    var forceUpdateAppVersion: RxSwift.Observable<String> { .just("") }

    var appStoreLink: RxSwift.Observable<String> { .just("") }

    var allProductsObservable: RxSwift.Observable<AvailableProducts> { .just(.empty) }

    func initialize() {}

    func closePaywallButtonDelay() async throws -> Int {
        1
    }

    func isLongOnboardingEnabled() async throws -> Bool {
        true
    }

    func resetPricingExp() {}

    var productIds: RxSwift.Observable<[String]> { .just([]) }

    var paywallProductIds: RxSwift.Observable<[String]> { .just([]) }

    var onboardingPaywallProductIds: RxSwift.Observable<[String]> { .just([]) }
}
