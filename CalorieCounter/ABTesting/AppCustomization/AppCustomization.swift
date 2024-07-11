//
//  AppCustomization.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//

import Foundation
import AppStudioABTesting
import RxSwift
import AppStudioServices

protocol AppCustomization {
    var dayLogLimit: Int { get }
    var forceUpdateAppVersion: Observable<String> { get }
    var appStoreLink: Observable<String> { get }
    var allProductsObservable: Observable<AvailableProducts> { get }
    var discountPaywallExperiment: Observable<DiscountPaywallInfo?> { get }
    func initialize()
    func shouldForceUpdate() async throws -> Bool
    func closePaywallButtonDelay() async throws -> Int
    func isLongOnboardingEnabled() async throws -> Bool
    func resetPricingExp()
    func resetDiscountExp()
    func canShowRateUsDialog() async throws -> Bool
    // TODO: - add app cutomization functions here
}
