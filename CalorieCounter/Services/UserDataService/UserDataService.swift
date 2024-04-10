//  
//  UserDataService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import Foundation
import AppStudioModels

protocol UserDataService {
    var userData: ProfileCalculationInitialData? { get }
    var goalData: ProfileCalculationGoalData? { get }
    var weightPerDaySpeed: WeightMeasure? { get }
    var dietData: ProfileCalculationDietData? { get }
    func nutritionProfile(dayDate: Date) async throws -> NutritionProfile
    func saveData(initialData: ProfileCalculationInitialData,
                  goalData: ProfileCalculationGoalData,
                  weightPerDaySpeed: WeightMeasure,
                  dietData: ProfileCalculationDietData) async throws
    /// For debug purposes, do not use directly
    func save(date: Date, profile: NutritionProfile) async throws -> NutritionProfile
    func removeAllData()
}
