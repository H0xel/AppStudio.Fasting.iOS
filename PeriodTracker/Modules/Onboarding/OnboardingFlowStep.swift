//
//  OnboardingFlowStep.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 12.09.2024.
//

import Foundation

enum OnboardingFlowStep: Int, CaseIterable {
    case none
    case start
    case birthday
    case lastPeriodStarted
    case currentWeight
    case longLastPeriod
    case longTypicalCycle
    case regularIrregularCycle
    case useOfBrithControl
    case fertilityGoals
    case trackSpecificSymptoms
    case topics
    case features

    static var flowSteps: [OnboardingFlowStep] {
        allCases.filter { $0 != .start && $0 != .none }
    }
}
