//
//  AppCustomizationDependency.swift
//  AppStudioTemplate
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//

import Foundation
import Dependencies
import ABTesting

extension DependencyValues {
    var appCustomization: AppCustomization {
        self[AppCustomizationKey.self]
    }

    var lifeCycleDelegate: ExperimentLifecycleDelegate {
        self[ExperimentLifecycleDelegateKey.self]
    }

    var productIdsService: ProductIdsService {
        self[AppCustomizationKey.self]
    }
}

private enum AppCustomizationKey: DependencyKey {
    static let liveValue = AppCustomizationImpl()
}

private enum ExperimentLifecycleDelegateKey: DependencyKey {
    static let liveValue = ExperimentLifeCycleDelegateImpl()
}
