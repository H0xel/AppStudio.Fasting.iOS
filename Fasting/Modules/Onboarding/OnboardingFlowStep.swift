//
//  OnboardingFlowStep.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import Foundation

enum OnboardingFlowStep: Int, CaseIterable {
    case none
    case start
    case fastingGoal
    case sex
    case birthday
    case height
    case currentWeight
    case desiredWeight
    case activityLevel
    case specialEvent
    case specialEventDate

    static var flowSteps: [OnboardingFlowStep] {
        allCases.filter { $0 != .start && $0 != .none }
    }
}
