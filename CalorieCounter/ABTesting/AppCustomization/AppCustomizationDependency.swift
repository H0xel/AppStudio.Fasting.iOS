//
//  AppCustomizationDependency.swift
//  CalorieCounter
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
    static let liveValue: AppCustomization & ProductIdsService = AppCustomizationImpl()
    static let previewValue: AppCustomization & ProductIdsService = AppCustomizationPreview()
}

private enum ExperimentLifecycleDelegateKey: DependencyKey {
    static let liveValue = ExperimentLifeCycleDelegateImpl()
}
