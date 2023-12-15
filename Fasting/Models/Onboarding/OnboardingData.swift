//
//  OnboardingData.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

struct OnboardingData: Codable {
    let goals: Set<FastingGoal>
    let sex: Sex
    let birthdayDate: Date
    let height: HeightMeasure
    let weight: WeightMeasure
    let desiredWeight: WeightMeasure
    let activityLevel: ActivityLevel
    let specialEvent: SpecialEvent
    let specialEventDate: Date?
}
