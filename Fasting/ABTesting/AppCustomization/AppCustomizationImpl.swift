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

private let requiredAppVersionKey = "force_update_version"
private let closePaywallButtonDelayKey = "close_paywall_button_delay"
private let forceUpdateLink = "force_update_link"
private let isLongOnboardingEnabledKey = "long_onboarding_enabled"

class AppCustomizationImpl: BaseAppCustomization, AppCustomization, ProductIdsService {

    private let productIdsRelay = BehaviorRelay<[String]>(value: [])
    private let disposeBag = DisposeBag()

    func initialize() {
        @Dependency(\.lifeCycleDelegate) var lifeCycleDelegate
        super.initialize(lifecycleDelegate: lifeCycleDelegate)
        configurePricingExperiment()
    }

    var forceUpdateAppVersion: Observable<String> {
        remoteConfigValueObservable(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
    }

    var appStoreLink: Observable<String> {
        remoteConfigValueObservable(forKey: forceUpdateLink, defaultValue: "")
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

    func closePaywallButtonDelay() async throws -> Int {
        let value = try await remoteConfigValue(forKey: closePaywallButtonDelayKey, defaultValue: "3")
        return Int(value) ?? 3
    }

    func isLongOnboardingEnabled() async throws -> Bool {
        try await remoteConfigValue(forKey: isLongOnboardingEnabledKey, defaultValue: true)
    }

    // TODO: Протестить на то чтобы в кэше не сохранялось
//    func shouldForceUpdate() async throws -> Bool {
//        let requierdVersion: String = try await remoteConfigValue(forKey: requiredAppVersionKey,
//                                                                  defaultValue: Bundle.appVersion)
//        return !Bundle.lessOrEqualToCurrentVersion(requierdVersion)
//    }
}

enum PricingError: Error {
    case error
}

private extension AppCustomizationImpl {
    private var tryCount: Int {
        3
    }
    
    private var nextTryIntervalSeconds: Int {
        1
    }

    private func pricingExperimentName() async -> String {
        let remoteKey = "exp_pricing_active"
        let defaultName = "pricing_default"
        let experimentPrefix = "$"

        let observable = remoteConfigValueObservable(forKey: remoteKey, defaultValue: "")
            .map { name -> String in
                if name.isEmpty {
                    throw PricingError.error
                }
                return name
            }
            .retry(times: tryCount, withDelay: .seconds(nextTryIntervalSeconds))
            .catchAndReturn(defaultName)
            .map { remoteValue in
                if remoteValue.hasPrefix(experimentPrefix) {
                    return remoteValue.substring(from: experimentPrefix.count)
                }
                return defaultName
            }

        do {
            for try await value in observable.values.prefix(1) {
                return value
            }
            throw PricingError.error
        } catch {
            return defaultName
        }
    }

    private func configurePricingExperiment() {
        experimentValueObservable(forType: PricingOngoingExperiment.self, defaultValue: .empty)
            .map { info -> SubscriptionInfo in
                if info == .empty {
                    throw PricingError.error
                }
                return info
            }
            .retry(times: tryCount, withDelay: .seconds(nextTryIntervalSeconds))
            .catchAndReturn(SubscriptionInfo.base)
            .map { $0.productIds }
            .bind(to: productIdsRelay)
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
