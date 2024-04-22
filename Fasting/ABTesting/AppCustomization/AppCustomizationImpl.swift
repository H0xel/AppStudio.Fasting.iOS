//
//  AppCustomizationImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//


import Foundation
import AppStudioABTesting
import AppStudioNavigation
import RxRelay
import RxSwift
import Dependencies
import ABTesting
import AppStudioServices

private let requiredAppVersionKey = "force_update_version"
private let closePaywallButtonDelayKey = "close_paywall_button_delay"
private let forceUpdateLink = "force_update_link"
private let isLongOnboardingEnabledKey = "long_onboarding_enabled"
private let fastingCyclesLimitKey = "fasting_cycles_limit"

class AppCustomizationImpl: BaseAppCustomization, AppCustomization, ProductIdsService {

    let productIdsRelay = BehaviorRelay<[String]>(value: [])
    let discountRelay = BehaviorRelay<DiscountPaywallInfo>(value: .empty)
    let allMonetizationRelay = BehaviorRelay<AllMonetizationExperimentVariant>(value: .control)
    let disposeBag = DisposeBag()

    func initialize() {
        @Dependency(\.lifeCycleDelegate) var lifeCycleDelegate
        super.initialize(lifecycleDelegate: lifeCycleDelegate)
        configureExperimentsOnStartApp()
    }

    var forceUpdateAppVersion: Observable<String> {
        remoteConfigValueObservable(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
    }

    var appStoreLink: Observable<String> {
        remoteConfigValueObservable(forKey: forceUpdateLink, defaultValue: "")
    }

    var fastingLimitCycles: Int {
        let remoteValueLimit = value(forKey: fastingCyclesLimitKey) ?? ""
        let defaultLimitCycles = 3
        return Int(remoteValueLimit) ?? defaultLimitCycles
    }

    override func registerExperiments() async {
        // TODO: - Register experiments here

        // MARK: - Examples
        // 1) Register experiment with default migration
//        await register(experiment: TestAAExperiment())

        // 2) Register experiment only for new user
//        await registerForNewUser(experiment: OnboardingNotificationsExperiment())

        // 3) Register experiment with custom migration
//        await register(experiment: TestAAExperiment(), migration: ExperimentMigration)

        let experimentName = await pricingExperimentName()

        await register(experiment: PricingOngoingExperiment(experimentName: experimentName))
        await register(experiment: TrialExperiment())
        await register(experiment: AllMonetizationExperiment())

        let discountExperimentName = await discountExperimentName()
        await register(experiment: DiscountPaywallExperiment(experimentName: discountExperimentName))
    }

    var productIds: Observable<[String]> {
        productIdsRelay.asObservable()
    }

    var paywallProductIds: Observable<[String]> {
        productIds
    }

    var onboardingPaywallProductIds: Observable<[String]> {
        experimentValueObservable(forType: TrialExperiment.self, defaultValue: .control)
            .map { [$0.onboardingPaywallSubscriptionIdentifier] }
    }

    var discountPaywallExperiment: Observable<DiscountPaywallInfo?> {
        discountRelay.asObservable()
            .map { return $0.paywallType != nil ? $0 : nil }
    }

    var isMonetizationExpAvailable: Observable<Bool> {
        allMonetizationRelay.asObservable()
            .map { $0 == .test }
    }

    func requiredAppVersion() async throws -> String {
        try await remoteConfigValue(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
    }

    func closePaywallButtonDelay() async throws -> Int {
        let value = try await remoteConfigValue(forKey: closePaywallButtonDelayKey, defaultValue: "3")
        return Int(value) ?? 3
    }

    func isLongOnboardingEnabled() async throws -> Bool {
        try await remoteConfigValue(forKey: isLongOnboardingEnabledKey, defaultValue: true)
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

    // TODO: Протестить на то чтобы в кэше не сохранялось
//    func shouldForceUpdate() async throws -> Bool {
//        let requierdVersion: String = try await remoteConfigValue(forKey: requiredAppVersionKey,
//                                                                  defaultValue: Bundle.appVersion)
//        return !Bundle.lessOrEqualToCurrentVersion(requierdVersion)
//    }
}

private extension AppCustomizationImpl {
    func configureExperimentsOnStartApp() {
        configureMonetizationExp()
        configurePricingExperiment()
        configureDiscountExperiment()
    }

    func configureMonetizationExp() {
        experimentValueObservable(forType: AllMonetizationExperiment.self, defaultValue: .control)
            .map { info in
                if info == .control {
                    throw DiscountError.error
                }
                return info
            }
            .observe(on: MainScheduler.asyncInstance)
            .retry(times: 3, withDelay: .seconds(1))
            .catchAndReturn(.control)
            .bind(to: allMonetizationRelay)
            .disposed(by: disposeBag)
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
