//  
//  DailyCalorieBudgetInput.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import Foundation

struct DailyCalorieBudgetInput {
    let dietData: ProfileCalculationDietData
    let rateSpeed: WeightMeasure
    let initialData: ProfileCalculationInitialData
    let goalData: ProfileCalculationGoalData
    let calculation: ProfileCalculationOutput
}

extension DailyCalorieBudgetInput {

    var descriptions: [DailyCalorieBudgetDescriptionView.ViewData] {
        var descriptions: [DailyCalorieBudgetDescriptionView.ViewData] = []

        let estimatedExpenditure: DailyCalorieBudgetDescriptionView.ViewData = .init(
            subtitle: DailyCalorieBudgetDescriptionLocalizationConstructor.kcal(
                amount: calculation.totalDailyEnergyExpenditures.formattedCaloriesString
            ),
            description: DailyCalorieBudgetDescriptionLocalizationConstructor.estimatedExpenditure(
                kcal: calculation.totalDailyEnergyExpenditures.formattedCaloriesString
            ),
            type: .estimatedExpenditure
        )

        descriptions.append(estimatedExpenditure)
        let calorieBudget = calculation.budgetInGramms.calories.formattedCaloriesString
        let dailyCalorieGoal: DailyCalorieBudgetDescriptionView.ViewData = .init(
            subtitle: DailyCalorieBudgetDescriptionLocalizationConstructor.kcal(amount: calorieBudget),
            description: DailyCalorieBudgetDescriptionLocalizationConstructor.dailyCalorieGoal(
                status: goalData.calorieGoal,
                rate: rateSpeed.valueWithUnits,
                kcal: calorieBudget),
            type: .dailyCalorieGoal
        )

        descriptions.append(dailyCalorieGoal)

        if goalData.calorieGoal != .maintain {
            let estimatedDate = calculation.successDate.currentLocaleFormatted(with: "MMMdyyyy")
            let kcal = goalData.calorieGoal == .lose ?
            calculation.totalDailyEnergyExpenditures - calculation.budgetInGramms.calories :
            calculation.budgetInGramms.calories - calculation.totalDailyEnergyExpenditures
            let estimatedAchievementDate: DailyCalorieBudgetDescriptionView.ViewData = .init(
                subtitle: estimatedDate,
                description: DailyCalorieBudgetDescriptionLocalizationConstructor.estimatedAchievementDate(
                    status: goalData.calorieGoal == .lose
                    ? .deficit(kcal: kcal.formattedCaloriesString, rate: rateSpeed.valueWithUnits)
                    : .surplus(kcal: kcal.formattedCaloriesString, rate: rateSpeed.valueWithUnits),
                    date: estimatedDate
                ),
                type: .estimatedAchievementDate)

            descriptions.append(estimatedAchievementDate)
        }

        let dayProtein = calculation.budgetInGramms.proteins
        let weight = initialData.weight

        let gramms = String(format: "%.2f", dayProtein / weight.value)
        let targetPerGramm = "\(gramms) g/\(weight.units.title)"

        let targetProtein: DailyCalorieBudgetDescriptionView.ViewData = .init(
            subtitle: targetPerGramm,
            description: DailyCalorieBudgetDescriptionLocalizationConstructor.targetProtein(
                status: goalData.calorieGoal,
                proteinTarget: targetPerGramm
            ),
            type: .targetProtein
        )

        descriptions.append(targetProtein)

        let dietType: DailyCalorieBudgetDescriptionView.ViewData = .init(
            subtitle: dietData.dietType.title,
            description: DailyCalorieBudgetDescriptionLocalizationConstructor.dietType(
                dietType: dietData.dietType.title
            ),
            type: .dietType
        )

        descriptions.append(dietType)
        return descriptions
    }

    static var mock: DailyCalorieBudgetInput {
        .init(dietData: .init(proteinLevel: .extraHigh, dietType: .balanced),
              rateSpeed: .init(value: 1, units: .kg),
              initialData: .init(sex: .male,
                                 birthday: .now,
                                 height: .init(centimeters: 184),
                                 weight: .init(value: 112, units: .kg),
                                 activityLevel: .sedentary,
                                 exerciseActivity: .sessionsPerWeek1to3,
                                 activityType: .cardio),
              goalData: .init(targetWeight: .init(value: 90, units: .kg),
                              calorieGoal: .lose),
              calculation: .init(totalDailyEnergyExpenditures: 2377,
                                 successDate: .now,
                                 budget: .mock,
                                 budgetInGramms: .mock))
    }
}


extension [DailyCalorieBudgetDescriptionView.ViewData] {
    static var mock: [DailyCalorieBudgetDescriptionView.ViewData] {
        [
            .init(
                subtitle: DailyCalorieBudgetDescriptionLocalizationConstructor.kcal(amount: "1,234"),
                description: DailyCalorieBudgetDescriptionLocalizationConstructor.estimatedExpenditure(kcal: "1,234"),
                type: .estimatedExpenditure),
            .init(
                subtitle: DailyCalorieBudgetDescriptionLocalizationConstructor.kcal(amount: "1,234"),
                description: DailyCalorieBudgetDescriptionLocalizationConstructor.dailyCalorieGoal(
                    status: .lose,
                    rate: "1.4 lb",
                    kcal: "1,234"),
                type: .dailyCalorieGoal),
            // Если не выбран maintain
            .init(
                subtitle: "May 13, 2024",
                description: DailyCalorieBudgetDescriptionLocalizationConstructor.estimatedAchievementDate(
                    status: .deficit(kcal: "1,234", rate: "1.4 lb"),
                    date: "May 13, 2024"
                ),
                type: .estimatedAchievementDate),
            //
            .init(
                subtitle: "0.75 g/Ib",
                description: DailyCalorieBudgetDescriptionLocalizationConstructor.targetProtein(
                    status: .lose,
                    proteinTarget: "0.75 g/Ib"
                ),
                type: .targetProtein),
            .init(
                subtitle: "Balanced",
                description: DailyCalorieBudgetDescriptionLocalizationConstructor.dietType(dietType: "Balanced"),
                type: .dietType)
        ]
    }
}
