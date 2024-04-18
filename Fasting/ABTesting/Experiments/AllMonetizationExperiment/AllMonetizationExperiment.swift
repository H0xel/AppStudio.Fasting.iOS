//
//  AllMonetizationExperiment.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.04.2024.
//

import Foundation
import AppStudioABTesting

enum AllMonetizationExperimentVariant: String, Codable {
    case test
    case control
}

class AllMonetizationExperiment: AppStudioExperimentWithRemoteConfig<AllMonetizationExperimentVariant> {
    init() {
        super.init(experimentName: "exp5_alt_monetization", defaultValue: .control)
    }
}
