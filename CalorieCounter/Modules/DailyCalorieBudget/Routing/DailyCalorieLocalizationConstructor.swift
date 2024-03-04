//
//  DailyCalorieLocalizationConstructor.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 11.01.2024.
//

import Foundation

enum DailyCalorieBudgetDescriptionLocalizationConstructor {
    enum AchievementDateStatus {
        case deficit(kcal: String, rate: String)
        case surplus(kcal: String, rate: String)
    }

    static func kcal(amount: String) -> String {
        String(format: NSLocalizedString("OnboardingEstimatedExpenditureView.title", comment: ""), amount)
    }

    static func estimatedExpenditure(kcal: String) -> String {
        let description = NSLocalizedString("DailyCalorieBudget.estimatedExpenditure.description", comment: "")
        return String(format: description, kcal)
    }

    static func dailyCalorieGoal(status: CalorieGoal, rate: String, kcal: String) -> String {

        var weightStatus: String {
            switch status {
            case .lose:
                let looseStatus = NSLocalizedString("DailyCalorieBudget.dailyCalorieGoal.description.loose",
                                                   comment: "")
                return String(format: looseStatus, rate)
            case .gain:
                let looseStatus = NSLocalizedString("DailyCalorieBudget.dailyCalorieGoal.description.gain",
                                                   comment: "")
                return String(format: looseStatus, rate)
            case .maintain:
                return NSLocalizedString("DailyCalorieBudget.dailyCalorieGoal.description.maintain", comment: "")
            }
        }

        let description = NSLocalizedString("DailyCalorieBudget.dailyCalorieGoal.description", comment: "")
        return String(format: description, arguments: [weightStatus, self.kcal(amount: kcal)])
    }

    static func estimatedAchievementDate(status: AchievementDateStatus, date: String) -> String {
        var achievementStatus: String {
            switch status {
            case let .deficit(kcal, rate):
                let deficitStatus = NSLocalizedString("DailyCalorieBudget.estimatedAchievementDate.description.deficit",
                                                   comment: "")
                return String(format: deficitStatus, arguments: [kcal, rate])
            case let .surplus(kcal, rate):
                let surplusStatus = NSLocalizedString("DailyCalorieBudget.estimatedAchievementDate.description.surplus",
                                                   comment: "")
                return String(format: surplusStatus, arguments: [kcal, rate])
            }
        }


        let description = NSLocalizedString("DailyCalorieBudget.estimatedAchievementDate.description", comment: "")
        return String(format: description, arguments: [achievementStatus, date])
    }

    static func targetProtein(status: CalorieGoal, proteinTarget: String) -> String {
        let weightStatus = NSLocalizedString("DailyCalorieBudget.targetProtein.description.\(status.rawValue)",
                                             comment: "")

        let description = NSLocalizedString("DailyCalorieBudget.targetProtein.description", comment: "")
        return String(format: description, arguments: [weightStatus, proteinTarget])
    }

    static func dietType(dietType: String) -> String {
        let description = NSLocalizedString( "DailyCalorieBudget.dietType.description", comment: "")
        return String(format: description, dietType)
    }
}
