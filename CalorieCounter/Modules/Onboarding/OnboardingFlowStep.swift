//
//  OnboardingFlowStep.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import Foundation

enum OnboardingFlowStep: Int, CaseIterable {
    case none
    case start
    case sex
    case birthday
    case height
    case currentWeight
    case activityLevel
    case howOftenDoYouExercise
    case whatTrainingYouDoing
    case estimatedExpenditure
    case calorieGoal
    case desiredWeight
    case fastCalorieBurn
    case dietType
    case proteinLevel

    static var flowSteps: [OnboardingFlowStep] {
        allCases.filter { $0 != .start && $0 != .none }
    }
}
