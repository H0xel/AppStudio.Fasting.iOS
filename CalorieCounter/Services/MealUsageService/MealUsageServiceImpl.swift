//  
//  MealUsageServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies
import Foundation

class MealUsageServiceImpl: MealUsageService {

    @Dependency(\.mealUsageRepository) private var mealUsageRepository
    @Dependency(\.mealItemService) private var mealItemService

    func incrementUsage(_ mealItem: MealItem, mealType: MealType) async throws -> MealUsage {
        if let usage = try await mealUsageRepository.usage(byMealId: mealItem.id, type: mealType) {
            return try await mealUsageRepository.save(usage.incremented)
        }
        let usage = MealUsage(id: UUID().uuidString,
                              usage: 1,
                              mealId: mealItem.id,
                              mealType: mealType)
        return try await mealUsageRepository.save(usage)
    }

    func decrementUsage(_ mealItem: MealItem, mealType: MealType) async throws {
        let usages = try await mealUsageRepository.usage(byMealId: mealItem.id)

        guard let targetUsage = usages.first(where: { $0.mealId == mealItem.id && $0.mealType == mealType }) else {
            return
        }
        let decrementedUsage = targetUsage.decremented
        if decrementedUsage.usage > 0 {
            _ = try await mealUsageRepository.save(decrementedUsage)
            return
        }

        try await mealUsageRepository.delete(byId: decrementedUsage.id)

        let otherUsages = usages.filter { $0.id != decrementedUsage.id }
        if otherUsages.isEmpty {
            try await mealItemService.delete(byId: mealItem.id)
        }
    }

    func favoriteMealItems(count: Int, mealType: MealType) async throws -> [MealItem] {
        let usages = try await sortedUsage(count: count, mealType: mealType)
        var result: [MealItem] = []
        for usage in usages {
            if let mealItem = try await mealItemService.mealItem(byId: usage.mealId) {
                result.append(mealItem)
            }
        }
        return result
    }

    func sortedUsage(count: Int, mealType: MealType) async throws -> [MealUsage] {
        try await mealUsageRepository.sortedUsage(count: count, mealType: mealType)
    }
}
