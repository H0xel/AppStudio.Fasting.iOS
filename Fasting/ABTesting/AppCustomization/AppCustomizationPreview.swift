//
//  AppCustomizationPreview.swift
//  Fasting
//
//  Created by Amakhin Ivan on 15.02.2024.
//

import Foundation
import RxRelay
import RxSwift
import AppStudioServices

class AppCustomizationPreview: AppCustomization, ProductIdsService {

    var isMonetizationExpAvailable: RxSwift.Observable<Bool> { .just(false) }

    var fastingLimitCycles: Int { 3 }

    func resetDiscountExp() {}

    var discountPaywallExperiment: RxSwift.Observable<DiscountPaywallInfo?> { .just(.empty) }

    func resetPricingExp() {}

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

    var productIds: RxSwift.Observable<[String]> { .just([]) }

    var paywallProductIds: RxSwift.Observable<[String]> { .just([]) }

    var onboardingPaywallProductIds: RxSwift.Observable<[String]> { .just([]) }
}
