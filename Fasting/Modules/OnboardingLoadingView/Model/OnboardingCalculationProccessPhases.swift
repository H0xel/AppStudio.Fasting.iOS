//
//  OnboardingCalculationProccessPhases.swift
//  Fasting
//
//  Created by Denis Khlopin on 11.12.2023.
//

import Foundation

enum OnboardingCalculationProccessPhases: String, CaseIterable {
    case phase1
    case phase2
    case phase3
    case phase4
    case phase5
    case phase6

    var title: String {
        switch self {
        case .phase1, .phase2, .phase3:
            return NSLocalizedString("OnboardingCalculationProccess.progress.title1",
                                     comment: "Analyzing your results...")
        case .phase4, .phase5, .phase6:
            return NSLocalizedString("OnboardingCalculationProccess.progress.title2",
                                     comment: "Creating your plan...")
        }
    }

    var description: String {
        NSLocalizedString("OnboardingCalculationProccess.\(rawValue)", comment: "")
    }
}
