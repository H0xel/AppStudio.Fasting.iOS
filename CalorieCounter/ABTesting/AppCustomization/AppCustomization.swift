//
//  AppCustomization.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//

import Foundation
import AppStudioABTesting
import RxSwift

protocol AppCustomization {
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
    // TODO: - add app cutomization functions here
}
