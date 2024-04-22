//
//  AppCustomizationImpl+Pricing.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.01.2024.
//

import Foundation
import MunicornFoundation
import AppStudioABTesting
import RxRelay
import RxSwift
import Dependencies

enum PricingError: Error {
    case error
}

/// PRICING EXPERIMENT HELPER
extension AppCustomizationImpl {
    private var tryCount: Int {
        3
    }

    private var nextTryIntervalSeconds: Int {
        1
    }

    func pricingExperimentName() async -> String {
        @Dependency(\.cloudStorage) var cloudStorage

        if let name = cloudStorage.pricingExperimentName {
            return name
        }

        let remoteKey = "exp_pricing_active"
        let defaultName = "pricing_default"
        let experimentPrefix = "$"

        let observable = remoteConfigValueObservable(forKey: remoteKey, defaultValue: "")
            .observe(on: MainScheduler.asyncInstance)
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
                cloudStorage.pricingExperimentName = value
                return value
            }
            throw PricingError.error
        } catch {
            cloudStorage.pricingExperimentName = defaultName
            return defaultName
        }
    }

    func configurePricingExperiment() {
        @Dependency(\.productProvider) var productProvider
        @Dependency(\.cloudStorage) var cloudStorage

        Observable.just(cloudStorage.pricingExperimentProductIds ?? productProvider.defaultProductIds)
            .bind(to: productIdsRelay)
            .disposed(by: disposeBag)

        Observable.combineLatest(
            experimentValueObservable(forType: PricingOngoingExperiment.self, defaultValue: .empty),
            experimentValueObservable(forType: AllMonetizationExperiment.self, defaultValue: .control)
        )
        .map { info, allMonetizationExp in
            if allMonetizationExp == .test {
                return SubscriptionInfo.allMonetization
            }
            if info == .empty {
                throw PricingError.error
            }
            return info
        }
        .retry(times: tryCount, withDelay: .seconds(nextTryIntervalSeconds))
        .catchAndReturn(SubscriptionInfo.base)
        .map {
            cloudStorage.pricingExperimentProductIds = $0.productIds
            return $0.productIds
        }
        .bind(to: productIdsRelay)
        .disposed(by: disposeBag)
    }

    func resetPricingExp() {
        @Dependency(\.cloudStorage) var cloudStorage
        cloudStorage.pricingExperimentName = nil
        cloudStorage.pricingExperimentProductIds = nil
    }
}

private let pricingExperimentNameKey = "AppStudio.pricingExperimentNameKey"
private let pricingExperimentProductIdsKey = "AppStudio.pricingExperimentProductIdsKey"

extension CloudStorage {
    fileprivate var pricingExperimentName: String? {
        get { get(key: pricingExperimentNameKey, defaultValue: nil)}
        set { set(key: pricingExperimentNameKey, value: newValue)}
    }

    var pricingExperimentProductIds: [String]? {
        get { get(key: pricingExperimentProductIdsKey, defaultValue: nil)}
        set { set(key: pricingExperimentProductIdsKey, value: newValue)}
    }
}
