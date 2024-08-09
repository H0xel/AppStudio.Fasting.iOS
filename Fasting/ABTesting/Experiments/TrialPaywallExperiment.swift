//
//  TrialPaywallExperiment.swift
//  Fasting
//
//  Created by Amakhin Ivan on 05.08.2024.
//

import AppStudioABTesting
import Dependencies
import AppStudioServices

enum TrialPaywallVariant: String, Codable {
    case test
    case control
}

class TrialPaywallExperiment: AppStudioExperimentWithRemoteConfig<TrialPaywallVariant> {
    init() {
        super.init(experimentName: "exp_trial_offer", defaultValue: .control)
    }
}
