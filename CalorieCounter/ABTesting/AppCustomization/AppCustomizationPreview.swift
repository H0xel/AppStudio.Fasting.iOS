//
//  AppCustomizationPreview.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 15.02.2024.
//


import Foundation
import RxRelay
import RxSwift
import AppStudioServices

class AppCustomizationPreview: AppCustomization, ProductIdsService {
    var dayLogLimit: Int { 3 }

    func resetDiscountExp() {}
    
    var discountPaywallExperiment: RxSwift.Observable<DiscountPaywallInfo?> {
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

    func canShowRateUsDialog() async throws -> Bool {
        true
    }
}
