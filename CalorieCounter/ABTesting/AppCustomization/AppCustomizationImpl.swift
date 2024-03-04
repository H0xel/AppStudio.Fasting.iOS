//
//  AppCustomizationImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//


import Foundation
import AppStudioABTesting
import AppStudioNavigation
import RxRelay
import RxSwift
import Dependencies

private let requiredAppVersionKey = "force_update_version"
private let closePaywallButtonDelayKey = "close_paywall_button_delay"
private let forceUpdateLink = "force_update_link"
private let isLongOnboardingEnabledKey = "long_onboarding_enabled"

class AppCustomizationImpl: BaseAppCustomization, AppCustomization, ProductIdsService {

    let productIdsRelay = BehaviorRelay<[String]>(value: [])
    let disposeBag = DisposeBag()

    func initialize() {
        @Dependency(\.lifeCycleDelegate) var lifeCycleDelegate
        super.initialize(lifecycleDelegate: lifeCycleDelegate)

        // Uncoment to start pricing experiment
        configurePricingExperiment()

//         load product ids for the first time
        paywallProductIds
            .subscribe { productIds in
                print("productIds successfully loaded", productIds)
            }
            .disposed(by: disposeBag)
    }

    override func registerExperiments() async {
        let experimentName = await pricingExperimentName()
        await register(experiment: PricingOngoingExperiment(experimentName: experimentName))
        let discountExperimentName = await discountExperimentName()
        await register(experiment: DiscountPaywallExperiment(experimentName: discountExperimentName))

        // MARK: - Examples
        // 1) Register experiment with default migration
//        await register(experiment: TestAAExperiment())

        // 2) Register experiment only for new user
//        await registerForNewUser(experiment: OnboardingNotificationsExperiment())

        // 3) Register experiment with custom migration
//        await register(experiment: TestAAExperiment(), migration: ExperimentMigration)

        // 4) Register pricing experiment
//        await register(experiment: PricingOngoingExperiment(experimentName: pricingExperimentName))
    }

    var productIds: Observable<[String]> {
        productIdsRelay.asObservable()
    }

    var paywallProductIds: Observable<[String]> {
        productIds
    }

    var forceUpdateAppVersion: Observable<String> {
        remoteConfigValueObservable(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
    }

    var appStoreLink: Observable<String> {
        remoteConfigValueObservable(forKey: forceUpdateLink, defaultValue: "")
    }

    var allProductsObservable: Observable<AvailableProducts> {
        remoteConfigValueObservable(forKey: "all_products", defaultValue: "")
        .observe(on: MainScheduler.asyncInstance)
        .map {
            if $0.isEmpty { throw PricingError.error }
            return $0
        }
        .map { try AvailableProducts(json: $0) }
        .retry(times: 3, withDelay: .seconds(1))
        .catchAndReturn(.empty)
    }

    var discountPaywallExperiment: Observable<DiscountPaywallInfo> {
        experimentValueObservable(forType: DiscountPaywallExperiment.self, defaultValue: .empty)
            .map { info in
                if info.name == DiscountPaywallInfo.empty.name {
                    throw DiscountError.error
                }
                return info
            }
            .observe(on: MainScheduler.asyncInstance)
            .retry(times: 3, withDelay: .seconds(1))
            .catchAndReturn(.empty)
    }

    func shouldForceUpdate() async throws -> Bool {
        let requierdVersion: String = try await remoteConfigValue(forKey: requiredAppVersionKey,
                                                                  defaultValue: Bundle.appVersion)
        return !Bundle.lessOrEqualToCurrentVersion(requierdVersion)
    }

    func closePaywallButtonDelay() async throws -> Int {
        let value = try await remoteConfigValue(forKey: closePaywallButtonDelayKey, defaultValue: "3")
        return Int(value) ?? 3
    }

    func isLongOnboardingEnabled() async throws -> Bool {
        try await remoteConfigValue(forKey: isLongOnboardingEnabledKey, defaultValue: true)
    }
}

// MARK: - Requests examples

// MARK: - Get string value from remote config
// var remoteValue: String {
//     value(forKey: "value_key")
// }

// MARK: - Get experiment value as Observable
// var testAAExperiment: Observable<TestAAVariant> {
//    experimentValueObservable(forType: TestAAExperiment.self, defaultValue: .control)
//        .take(1)
// }

// MARK: - Get remote config value as Observable
// var requiredAppVersion: Observable<String> {
//    remoteConfigValueObservable(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
// }

// MARK: - Get experiment value as AnyPublisher
// var testAAExperiment: AnyPublisher<TestAAVariant, Never> {
//    experimentValuePublisher(forType: TestAAExperiment.self, defaultValue: .control)
// }

// MARK: - Get remote config value as AnyPublisher
// var requiredAppVersion: AnyPublisher<String, Never> {
//    remoteConfigValuePublisher(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
// }

// MARK: - Get experiment value async
// func testAAExperiment() async throws -> TestAAVariant {
//    try await experimentValue(forType: TestAAExperiment.self, defaultValue: .control)
// }

// MARK: - Get remote config value async
// func requiredAppVersion() async throws -> String {
//    try await remoteConfigValue(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
// }
