//
//  TrialExperiment.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 12.12.2023.
//

import Foundation
import AppStudioABTesting

enum TrialExperimentVariant: String, Codable {
    case test
    case control
}

class TrialExperiment: AppStudioExperimentWithRemoteConfig<TrialExperimentVariant> {
    
    init() {
        super.init(experimentName: "week_5_99_trial_no_trial", defaultValue: .control)
    }
}

extension TrialExperimentVariant {
    var onboardingPaywallSubscriptionIdentifier: String {
        switch self {
        case .control:
            return "com.municorn.Fasting.weekly_exp_1"
        case .test:
            return "com.municorn.Fasting.weekly_exp_2"
        }
    }
}
