//
//  UserDataServicePreview.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import Foundation

class UserDataServicePreview: UserDataService {


    var userData: ProfileCalculationInitialData? {
        nil
    }

    var goalData: ProfileCalculationGoalData? {
        nil
    }

    var weightPerDaySpeed: WeightMeasure? {
        nil
    }

    var dietData: ProfileCalculationDietData? {
        nil
    }

    func nutritionProfile(dayDate: Date) async throws -> NutritionProfile {
        return .mock
    }

    /// For debug purposes, do not use directly
    func save(date: Date, profile: NutritionProfile) async throws -> NutritionProfile {
        return .mock
    }

    func saveData(initialData: ProfileCalculationInitialData,
                  goalData: ProfileCalculationGoalData,
                  weightPerDaySpeed: WeightMeasure,
                  dietData: ProfileCalculationDietData) async throws {
    }

    func removeAllData() {
    }
}
