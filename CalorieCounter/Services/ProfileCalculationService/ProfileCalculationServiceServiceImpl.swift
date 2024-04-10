//
//  ProfileCalculationServiceServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//
import AppStudioFoundation
import Foundation
import AppStudioModels

class ProfileCalculationServiceServiceImpl: ProfileCalculationServiceService {

    func calculateMaintainEstimatedExpenditure(initialData: ProfileCalculationInitialData) -> Double {
        let leanBodyMass = leanBodyMass(initialData: initialData)
        let restingMetabolicRate = 500 + 22 * leanBodyMass
        let activityCoeff = initialData.activityLevel.generalActivityCoeff
        + initialData.exerciseActivity.exerciseActivityCoeff
        let totalDailyEnergyExpenditures = restingMetabolicRate * activityCoeff

        return totalDailyEnergyExpenditures
    }

    func calculateSpeedRange(
        initialData: ProfileCalculationInitialData,
        goalData: ProfileCalculationGoalData
    ) -> ProfileCalculationSpeedRange {

        ProfileCalculationSpeedRange(
            maxRange: .init(
                uncheckedBounds: (
                    lower: goalData.calorieGoal.maxPercentRange.lowerBound * initialData.weight.value,
                    upper: goalData.calorieGoal.maxPercentRange.upperBound * initialData.weight.value
                )
            ),
            recomendedRange: .init(
                uncheckedBounds: (
                    lower: goalData.calorieGoal.recomendedPercentRange.lowerBound * initialData.weight.value,
                    upper: goalData.calorieGoal.recomendedPercentRange.upperBound * initialData.weight.value
                )
            ),
            startingPoint: goalData.calorieGoal.startingPointPercent * initialData.weight.value,
            weightUnits: initialData.weight.units
        )
    }

    func calculateDailyCaloriesAndDate(
        initialData: ProfileCalculationInitialData,
        goalData: ProfileCalculationGoalData,
        weightPerDaySpeed: WeightMeasure
    ) -> DailyCalories {
        let weightUnits = WeightUnit.kg // input.weight.units
        let totalDailyEnergyExpenditures = calculateMaintainEstimatedExpenditure(initialData: initialData)

        guard goalData.calorieGoal != .maintain, let targetWeight = goalData.targetWeight else {
            return DailyCalories(calculatedCalorieBudget: totalDailyEnergyExpenditures,
                                 recomendedCalorieBudget: totalDailyEnergyExpenditures,
                                 successDate: .now)
        }

        let daysToGoal = Int(abs(
            (initialData.weight.normalizeValue - targetWeight.normalizeValue) / weightPerDaySpeed.normalizeValue
        ))
        let successDate = Date().add(days: daysToGoal)

        var calorieBudget = totalDailyEnergyExpenditures

        let deficit = weightPerDaySpeed.normalizeValue *
        (goalData.calorieGoal == .lose ? weightUnits.calorieLoosePerUnit : weightUnits.calorieGainPerUnit)
        calorieBudget += deficit

        let calculatedCalorieBudget = calorieBudget
        let recomendedCalorieBudget = max(1200, calorieBudget)

        return DailyCalories(calculatedCalorieBudget: calculatedCalorieBudget,
                             recomendedCalorieBudget: recomendedCalorieBudget,
                             successDate: successDate)
    }

    func calculate(
        initialData: ProfileCalculationInitialData,
        goalData: ProfileCalculationGoalData,
        weightPerDaySpeed: WeightMeasure,
        dietData: ProfileCalculationDietData
    ) -> ProfileCalculationOutput {

        let totalDailyEnergyExpenditures = calculateMaintainEstimatedExpenditure(initialData: initialData)

        let dayly = calculateDailyCaloriesAndDate(initialData: initialData,
                                                  goalData: goalData,
                                                  weightPerDaySpeed: weightPerDaySpeed)

        let calorieBudget = dayly.recomendedCalorieBudget

        // Calculate Nutrtion Profile (БЖУ)
        let proteinBudget = dietData.proteinLevel.grammPerKg(for: initialData.activityType)
        * initialData.weight.normalizeValue
        let proteinCaloriesBudget = proteinBudget * NutritionProfileContent.protein.caloriesPerGramm

        let otherCaloriesBudget = calorieBudget - proteinCaloriesBudget

        let minimumFatBudget: Double = initialData.height.normalizeValue < 150
        ? 30.0
        : (initialData.height.normalizeValue - 150) * 0.5 + 30.0

        var fatCaloriesBudget = otherCaloriesBudget * (1.0 - dietData.dietType.partOfCarb)
        let fatBudget = max(fatCaloriesBudget / NutritionProfileContent.fat.caloriesPerGramm, minimumFatBudget)
        fatCaloriesBudget = fatBudget * NutritionProfileContent.fat.caloriesPerGramm

        let carbohydratesCaloriesBudget = otherCaloriesBudget - fatCaloriesBudget
        let carbohydratesBudget = carbohydratesCaloriesBudget / NutritionProfileContent.carbohydrates.caloriesPerGramm

        return ProfileCalculationOutput(
            totalDailyEnergyExpenditures: totalDailyEnergyExpenditures,
            successDate: dayly.successDate,
            budget: .init(
                calories: calorieBudget,
                proteins: proteinCaloriesBudget,
                fats: fatCaloriesBudget,
                carbohydrates: carbohydratesCaloriesBudget
            ),
            budgetInGramms: .init(
                calories: calorieBudget,
                proteins: proteinBudget,
                fats: fatBudget,
                carbohydrates: carbohydratesBudget
            )
        )
    }

    func leanBodyMass(initialData: ProfileCalculationInitialData) -> Double {
        switch initialData.sex {
        case .male:
            (0.407 * initialData.weight.normalizeValue) + (0.267 * initialData.height.normalizeValue) - 19.2
        case .female, .other:
            (0.252 * initialData.weight.normalizeValue) + (0.473 * initialData.height.normalizeValue) - 48.3
        }
    }
}

private extension ActivityLevel {
    var generalActivityCoeff: Double {
        switch self {
        case .sedentary:
            1.0
        case .moderatelyActive:
            1.4
        case .veryActive:
            1.6
        }
    }
}

private extension ExerciseActivity {
    var exerciseActivityCoeff: Double {
        switch self {
        case .sessionsPerWeek0:
            0
        case .sessionsPerWeek1to3:
            0.1
        case .sessionsPerWeek4to6:
            0.2
        case .sessionsPerWeekMoreThan7:
            0.3
        }
    }
}

private extension WeightUnit {
    var calorieLoosePerUnit: Double {
        switch self {
        case .lb:
            -3500
        case .kg:
            -7800
        }
    }

    var calorieGainPerUnit: Double {
        switch self {
        case .lb:
            2500
        case .kg:
            5500
        }
    }
}

private extension ProteinLevel {
    private var activityTypeWeights: [ActivityType: Double] {
        switch self {
        case .low:
            [.noActivity: 1, .cardio: 1.2, .lifting: 1.4, .both: 1.4]
        case .moderate:
            [.noActivity: 1.28, .cardio: 1.52, .lifting: 1.76, .both: 1.76]
        case .high:
            [.noActivity: 1.56, .cardio: 1.84, .lifting: 2.12, .both: 2.12]
        case .extraHigh:
            [.noActivity: 1.84, .cardio: 2.16, .lifting: 2.48, .both: 2.48]
        }
    }

    func grammPerKg(for activityType: ActivityType) -> Double {
        activityTypeWeights[activityType] ?? 1.0
    }
}


enum NutritionProfileContent {
    case protein
    case fat
    case carbohydrates
    case alcohol

    var caloriesPerGramm: Double {
        switch self {
        case .protein:
            4
        case .fat:
            9
        case .carbohydrates:
            4
        case .alcohol:
            7
        }
    }
}
