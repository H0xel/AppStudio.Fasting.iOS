//
//  ProfileCalculationInput.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//

import Foundation
import AppStudioModels

struct ProfileCalculationInitialData: Codable {
    let sex: Sex
    let birthday: Date
    let height: HeightMeasure
    let weight: WeightMeasure
    let activityLevel: ActivityLevel
    let exerciseActivity: ExerciseActivity
    let activityType: ActivityType

    var age: Double {
        Double(Date().year - birthday.year)
    }

    func updated(sex: Sex? = nil,
                 birthday: Date? = nil,
                 height: HeightMeasure? = nil,
                 weight: WeightMeasure? = nil,
                 activityLevel: ActivityLevel? = nil,
                 exerciseActivity: ExerciseActivity? = nil,
                 activityType: ActivityType? = nil) -> ProfileCalculationInitialData {
        .init(sex: sex ?? self.sex,
              birthday: birthday ?? self.birthday,
              height: height ?? self.height,
              weight: weight ?? self.weight,
              activityLevel: activityLevel ?? self.activityLevel,
              exerciseActivity: exerciseActivity ?? self.exerciseActivity,
              activityType: activityType ?? self.activityType)
    }
}

struct ProfileCalculationGoalData: Codable {
    let targetWeight: WeightMeasure?
    let calorieGoal: CalorieGoal
}

struct ProfileCalculationDietData: Codable {
    let proteinLevel: ProteinLevel
    let dietType: DietType
}

struct ProfileCalculationSpeedRange {
    let maxRange: ClosedRange<Double>
    let recomendedRange: ClosedRange<Double>
    let startingPoint: Double
    let weightUnits: WeightUnit
}

struct DailyCalories {
    let calculatedCalorieBudget: Double
    let recomendedCalorieBudget: Double
    let successDate: Date
}


extension DailyCalories {
    func convert(startPointInRange: Bool,
                 burnPerWeek: String,
                 goal: CalorieGoal) -> OnboardingFastCalorieBurnView.ViewData {
        var description: String {
            if goal == .lose, calculatedCalorieBudget < 1200 {
                return Localization.description2
            }
            if startPointInRange {
                return goal == .lose ? Localization.description1LoseWeight : Localization.description1GainWeight
            }
            return ""
        }
        let calories = calculatedCalorieBudget.roundToNearest(10)
        let kcal = calories >= 1200 ? "~\(calories.formattedCaloriesString)" : "\(calories.formattedCaloriesString)"
        let underLineKcal = calories < 1200 ? "~\(recomendedCalorieBudget.formattedCaloriesString)" : nil
        return .init(burnPerWeek: burnPerWeek,
                     averageDailyCalories: .init(
                        kcal: kcal,
                        underLineKcal: underLineKcal
                     ),
                     estimatedAchievementDate: successDate.currentLocaleFormatted(with: "MMMdyyyy"),
                     description: description,
                     isLessThenMinimum: calories < 1200)
    }
}

private enum Localization {
    static let description1LoseWeight = NSLocalizedString("OnboardingFastCalorieView.loseWeight.description1",
                                                          comment: "")
    static let description1GainWeight = NSLocalizedString("OnboardingFastCalorieView.gainWeight.description1",
                                                          comment: "")
    static let description2 = NSLocalizedString("OnboardingFastCalorieView.description2", comment: "")
}
