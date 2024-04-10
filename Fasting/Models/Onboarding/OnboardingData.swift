//
//  OnboardingData.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation
import AppStudioModels

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

extension OnboardingData {
    func updated(
        goals: Set<FastingGoal>? = nil,
        sex: Sex? = nil,
        birthdayDate: Date? = nil,
        height: HeightMeasure? = nil,
        weight: WeightMeasure? = nil,
        desiredWeight: WeightMeasure? = nil,
        activityLevel: ActivityLevel? = nil,
        specialEvent: SpecialEvent? = nil,
        specialEventDate: Date? = nil
    ) -> OnboardingData {
        .init(
            goals: goals ?? self.goals,
            sex: sex ?? self.sex,
            birthdayDate: birthdayDate ?? self.birthdayDate,
            height: height ?? self.height,
            weight: weight ?? self.weight,
            desiredWeight: desiredWeight ?? self.desiredWeight,
            activityLevel: activityLevel ?? self.activityLevel,
            specialEvent: specialEvent ?? self.specialEvent,
            specialEventDate: specialEventDate ?? self.specialEventDate
        )
    }
}
