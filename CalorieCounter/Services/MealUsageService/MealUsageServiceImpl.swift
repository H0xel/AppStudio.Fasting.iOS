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
        for ingredient in mealItem.ingredients {
            let item = try await mealItemService
                .mealItem(byName: ingredient.mealName, creationType: ingredient.type) ?? ingredient
            _ = try await incrementUsage(item, mealType: mealType)
        }
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

        for ingredient in mealItem.ingredients {
            let item = try await mealItemService
                .mealItem(byName: ingredient.mealName, creationType: ingredient.type) ?? ingredient
            _ = try await decrementUsage(item, mealType: mealType)
        }

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

        guard mealItem.canBeDeletedOnZeroUsage else {
            return
        }
        let otherUsages = usages.filter { $0.id != decrementedUsage.id }
        if otherUsages.isEmpty {
            try await mealItemService.delete(byId: mealItem.id)
        }
    }

    func favoriteMealItems(from mealItemIds: [String],
                           count: Int,
                           mealType: MealType) async throws -> [MealItem] {
        let usages = try await mealUsageRepository.sortedUsage(count: count, mealType: mealType, from: mealItemIds)
        var result: [MealItem] = []
        for usage in usages {
            if let mealItem = try await mealItemService.mealItem(byId: usage.mealId) {
                result.append(mealItem)
            }
        }
        return result
    }

    func delete(byMealItemId id: String) async throws {
        let usages = try await mealUsageRepository.usage(byMealId: id)
        for usage in usages {
            try await mealUsageRepository.delete(byId: usage.id)
            await Task.yield()
        }
    }
}
