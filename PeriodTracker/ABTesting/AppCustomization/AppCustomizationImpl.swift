//
//  AppCustomizationImpl.swift
//  AppStudioTemplate
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
private let forceUpdateLink = "force_update_link"
private let closePaywallButtonDelayKey = "close_paywall_button_delay"

class AppCustomizationImpl: BaseAppCustomization, AppCustomization, ProductIdsService {
    var forceUpdateAppVersion: Observable<String> {
        remoteConfigValueObservable(forKey: requiredAppVersionKey, defaultValue: Bundle.appVersion)
    }

    var appStoreLink: Observable<String> {
        remoteConfigValueObservable(forKey: forceUpdateLink, defaultValue: "")
    }


    let productIdsRelay = BehaviorRelay<[String]>(value: [])
    let disposeBag = DisposeBag()

    func initialize() {
        @Dependency(\.lifeCycleDelegate) var lifeCycleDelegate
        super.initialize(lifecycleDelegate: lifeCycleDelegate)
        configurePricingExperiment()
    }

    override func registerExperiments() async {
        // TODO: - Register experiments here

        // MARK: - Examples
        // 1) Register experiment with default migration
//        await register(experiment: TestAAExperiment())

        // 2) Register experiment only for new user
//        await registerForNewUser(experiment: OnboardingNotificationsExperiment())

        // 3) Register experiment with custom migration
//        await register(experiment: TestAAExperiment(), migration: <#T##ExperimentMigration#>)

        // 4) Register pricing experiment
//        await register(experiment: PricingOngoingExperiment(experimentName: pricingExperimentName))
        let experimentName = await pricingExperimentName()
        await register(experiment: PricingOngoingExperiment(experimentName: experimentName))
    }

    var productIds: Observable<[String]> {
        productIdsRelay.asObservable()
    }

    var paywallProductIds: Observable<[String]> {
        productIds
    }

    func closePaywallButtonDelay() async throws -> Int {
        let value = try await remoteConfigValue(forKey: closePaywallButtonDelayKey, defaultValue: "3")
        return Int(value) ?? 3
    }
}

private extension AppCustomizationImpl {
    var pricingExperimentName: String {
        let remoteKey = "exp_pricing_active"
        let defaultName = "pricing_default"
        let experimentPrefix = "$"
        if let remoteValue = value(forKey: remoteKey),
           remoteValue.hasPrefix(experimentPrefix) {
            return remoteValue.substring(from: experimentPrefix.count)
        }
        return defaultName
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
