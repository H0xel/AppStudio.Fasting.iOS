//
//  OnboardingCalculationProccessPhases.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 11.12.2023.
//

import Foundation

enum OnboardingCalculationProccessPhases: String, CaseIterable {
    case phase1
    case phase2
    case phase3
    case phase4

    var title: String {
        switch self {
        case .phase1:
            return NSLocalizedString("OnboardingCalculationProccess.progress.title1",
                                     comment: "Analyzing your results...")
        case .phase2:
            return NSLocalizedString("OnboardingCalculationProccess.progress.title2",
                                     comment: "Aligning your plan to your goal...")
        case .phase3:
            return NSLocalizedString("OnboardingCalculationProccess.progress.title3",
                                     comment: "Adjusting plan to your information...")
        case .phase4:
            return NSLocalizedString("OnboardingCalculationProccess.progress.title4",
                                     comment: "All done! Your plan is ready")
        }
    }

    var description: String {
        NSLocalizedString("OnboardingCalculationProccess.\(rawValue)", comment: "")
    }
}
