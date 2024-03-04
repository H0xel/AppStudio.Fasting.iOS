//
//  NutritionProfileRepository.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.01.2024.
//

import Foundation

protocol NutritionProfileRepository {
    func nutritionProfile(dayDate: Date) async throws -> DatedNutritionProfile?
    @discardableResult
    func save(profile: DatedNutritionProfile) async throws -> DatedNutritionProfile
    func deleteFromSelectedDay(day: Date) async throws
}
