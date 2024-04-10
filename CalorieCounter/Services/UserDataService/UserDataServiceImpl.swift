//  
//  UserDataServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import Dependencies
import MunicornFoundation
import Foundation
import AppStudioModels

private let profileCalculationInitialDataKey = "profileCalculationInitialDataKey"
private let profileCalculationGoalDataKey = "profileCalculationGoalDataKey"
private let weightMeasureKey = "WeightMeasureKey"
private let profileCalculationDietDataKey = "ProfileCalculationDietDataKey"
private let calculationKey = "ProfileCalculationOutputKey"

class UserDataServiceImpl: UserDataService {

    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.profileCalculationServiceService) private var profileCalculationServiceService
    @Dependency(\.nutritionProfileRepository) private var nutritionProfileRepository

    var userData: ProfileCalculationInitialData? {
        cloudStorage.initialData
    }

    var goalData: ProfileCalculationGoalData? {
        cloudStorage.goalData
    }

    var weightPerDaySpeed: WeightMeasure? {
        cloudStorage.weightPerDaySpeed
    }

    var dietData: ProfileCalculationDietData? {
        cloudStorage.dietData
    }

    func nutritionProfile(dayDate: Date) async throws -> NutritionProfile {
        try await nutritionProfileRepository.nutritionProfile(dayDate: dayDate)?.profile ?? .empty
    }

    /// For debug purposes, do not use directly
    func save(date: Date, profile: NutritionProfile) async throws -> NutritionProfile {
        try await nutritionProfileRepository.deleteFromSelectedDay(day: date)
        return try await nutritionProfileRepository.save(profile: .init(startDate: date, profile: profile)).profile
    }

    func saveData(initialData: ProfileCalculationInitialData,
                  goalData: ProfileCalculationGoalData,
                  weightPerDaySpeed: WeightMeasure,
                  dietData: ProfileCalculationDietData) async throws {
        cloudStorage.saveData(initialData: initialData,
                              goalData: goalData,
                              weightPerDaySpeed: weightPerDaySpeed,
                              dietData: dietData)
        let calculation = profileCalculationServiceService.calculate(initialData: initialData,
                                                                     goalData: goalData,
                                                                     weightPerDaySpeed: weightPerDaySpeed,
                                                                     dietData: dietData)
        cloudStorage.saveCalculation(calculation)
        let profile = DatedNutritionProfile(startDate: .now,
                                            profile: calculation.budgetInGramms)
        try await nutritionProfileRepository.deleteFromSelectedDay(day: .now)
        try await nutritionProfileRepository.save(profile: profile)
    }

    func removeAllData() {
        cloudStorage.removeAllData()
    }
}

private extension CloudStorage {

    var calculation: ProfileCalculationOutput? {
        let json: String? = get(key: calculationKey)
        return try? ProfileCalculationOutput(json: json ?? "")
    }

    var initialData: ProfileCalculationInitialData? {
        let json: String? = get(key: profileCalculationInitialDataKey)
        return try? ProfileCalculationInitialData(json: json ?? "")
    }

    var goalData: ProfileCalculationGoalData? {
        let json: String? = get(key: profileCalculationGoalDataKey)
        return try? ProfileCalculationGoalData(json: json ?? "")
    }

    var weightPerDaySpeed: WeightMeasure? {
        let json: String? = get(key: weightMeasureKey)
        return try? WeightMeasure(json: json ?? "")
    }

    var dietData: ProfileCalculationDietData? {
        let json: String? = get(key: profileCalculationDietDataKey)
        return try? ProfileCalculationDietData(json: json ?? "")
    }

    func save(initialData: ProfileCalculationInitialData) {
        set(key: profileCalculationInitialDataKey, value: initialData.json())
    }

    func save(goalData: ProfileCalculationGoalData) {
        set(key: profileCalculationGoalDataKey, value: goalData.json())
    }

    func save(weightPerDaySpeed: WeightMeasure) {
        set(key: weightMeasureKey, value: weightPerDaySpeed.json())
    }

    func save(dietData: ProfileCalculationDietData) {
        set(key: profileCalculationDietDataKey, value: dietData.json())
    }

    func removeAllData() {
        set(key: profileCalculationInitialDataKey, value: "")
        set(key: profileCalculationGoalDataKey, value: "")
        set(key: weightMeasureKey, value: "")
        set(key: profileCalculationDietDataKey, value: "")
    }

    func saveData(initialData: ProfileCalculationInitialData,
                  goalData: ProfileCalculationGoalData,
                  weightPerDaySpeed: WeightMeasure,
                  dietData: ProfileCalculationDietData) {
        save(initialData: initialData)
        save(goalData: goalData)
        save(weightPerDaySpeed: weightPerDaySpeed)
        save(dietData: dietData)
    }

    func saveCalculation(_ calculation: ProfileCalculationOutput) {
        set(key: calculationKey, value: calculation.json())
    }
}
