//  
//  ProfileCalculationServiceService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//

import AppStudioModels

protocol ProfileCalculationServiceService {
    func calculateMaintainEstimatedExpenditure(initialData: ProfileCalculationInitialData) -> Double
    func calculateSpeedRange(
        initialData: ProfileCalculationInitialData,
        goalData: ProfileCalculationGoalData
    ) -> ProfileCalculationSpeedRange
    func calculateDailyCaloriesAndDate(
        initialData: ProfileCalculationInitialData,
        goalData: ProfileCalculationGoalData,
        weightPerDaySpeed: WeightMeasure
    ) -> DailyCalories
    func calculate(
        initialData: ProfileCalculationInitialData,
        goalData: ProfileCalculationGoalData,
        weightPerDaySpeed: WeightMeasure,
        dietData: ProfileCalculationDietData
    ) -> ProfileCalculationOutput
}
