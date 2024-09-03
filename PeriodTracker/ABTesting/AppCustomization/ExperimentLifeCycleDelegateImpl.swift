//
//  ExperimentLifeCycleDelegateImpl.swift
//  AppStudioTemplate
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//

import Foundation
import ABTesting
import Dependencies

class ExperimentLifeCycleDelegateImpl: ExperimentLifecycleDelegate {

    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService

    func experimentStarted(expId: String, value: String) {
        trackerService.track(.startedExperiment(expName: expId, variantId: value))
        userPropertyService.set(userProperties: [expId: value as NSString])
    }

    func forcedValueApplied(expId: String, value: String) {
        trackerService.track(.appliedForcedVariant(expName: expId, variantId: value))
        userPropertyService.set(userProperties: [expId: (value.hasSuffix("!") ? value : "\(value)!") as NSString])
    }
}
