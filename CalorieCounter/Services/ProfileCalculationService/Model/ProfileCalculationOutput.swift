//
//  ProfileCalculationOutput.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//

import Foundation

struct ProfileCalculationOutput: Codable {
    let totalDailyEnergyExpenditures: Double
    let successDate: Date
    let budget: NutritionProfile
    let budgetInGramms: NutritionProfile
}
