//
//  AppCustomizationImpl+Discount.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 21.02.2024.
//

import Foundation
import MunicornFoundation
import AppStudioABTesting
import RxRelay
import RxSwift
import Dependencies

enum DiscountError: Error {
    case error
}

/// DISCOUNT EXPERIMENT HELPER
extension AppCustomizationImpl {
    private var tryCount: Int {
        3
    }

    private var nextTryIntervalSeconds: Int {
        1
    }

    func discountExperimentName() async -> String {
        @Dependency(\.cloudStorage) var cloudStorage

        if let name = cloudStorage.discountExperimentName {
            return name
        }

        let remoteKey = "discount_active"
        let defaultName = "discount_empty"
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
                cloudStorage.discountExperimentName = value
                return value
            }
            throw PricingError.error
        } catch {
            cloudStorage.discountExperimentName = defaultName
            return defaultName
        }
    }

    func configureDiscountExperiment() {
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
            .bind(to: discountRelay)
            .disposed(by: disposeBag)
    }

    func resetDiscountExp() {
        @Dependency(\.cloudStorage) var cloudStorage
        cloudStorage.discountExperimentName = nil
    }
}

private let discountExperimentNameKey = "AppStudio.discountExperimentNameKey"

private extension CloudStorage {
    var discountExperimentName: String? {
        get { get(key: discountExperimentNameKey, defaultValue: nil)}
        set { set(key: discountExperimentNameKey, value: newValue)}
    }
}


