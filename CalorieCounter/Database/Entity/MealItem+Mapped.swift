//
//  MealItem+Mapped.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 01.05.2024.
//

import Foundation
import MunicornCoreData

extension MealItem: EntityMappable {

    init(entity: MealItemEntity) throws {
        guard let id = entity.id,
              let name = entity.name else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.type = MealCreationType(rawValue: Int(entity.creationType)) ?? .chatGPT

        self.name = name
        self.subTitle = entity.subtitle
        self.notes = entity.notes
        
        if let oldIngredients = try? [OldIngredient](json: entity.ingredients ?? "") {
            ingredients = oldIngredients.asMealArray
        } else {
            ingredients = (try? [MealItem](json: entity.ingredients ?? "")) ?? []
        }

        self.normalizedProfile = .init(calories: entity.normalizedProfileCalories,
                                       proteins: entity.normalizedProfileProteins,
                                       fats: entity.normalizedProfileFats,
                                       carbohydrates: entity.normalizedProfileCarbohydrates)
        self.additionInfo = entity.hasAdditionalInfo
        ? .init(saturedFat: entity.additionalInfoSaturedFat,
                cholesterol: entity.additionalInfoCholesterol,
                sodium: entity.additionalInfoSodium,
                dietaryFiber: entity.additionalInfoDietaryFiber,
                sugars: entity.additionalInfoSugars,
                potassium: entity.additionalInfoPotassium)
        : nil

        self.totalWeight = entity.hasTotalWeight ? entity.totalWeight : nil
        self.servingMultiplier = entity.servingMultiplier > 0 ? entity.servingMultiplier : 1.0
        self.serving = .init(weight: entity.hasServingWeight ? entity.servingWeight : nil,
                             measure: entity.servingMeasure ?? "",
                             quantity: entity.servingQuantity)

        let servs = try? [MealServing].init(json: entity.servingsJson ?? "")
        self.servings = servs ?? .defaultServings
        self.dateUpdated = entity.dateUpdated ?? .now
        self.brandFoodId = entity.brandFoodId
        self.amountPer = entity.hasAmountPer ? entity.amountPer : nil
        self.barCode = entity.barCode
    }

    func map(to entity: MealItemEntity) {
        entity.id = id
        entity.creationType = Int16(type.rawValue)

        entity.name = name
        entity.subtitle = subTitle
        entity.notes = notes

        entity.ingredients = ingredients.json()

        entity.normalizedProfileCalories = normalizedProfile.calories
        entity.normalizedProfileProteins = normalizedProfile.proteins
        entity.normalizedProfileFats = normalizedProfile.fats
        entity.normalizedProfileCarbohydrates = normalizedProfile.carbohydrates

        if let additionInfo {
            entity.hasAdditionalInfo = true
            entity.additionalInfoSaturedFat = additionInfo.saturedFat ?? 0
            entity.additionalInfoCholesterol = additionInfo.cholesterol ?? 0
            entity.additionalInfoSodium = additionInfo.sodium ?? 0
            entity.additionalInfoDietaryFiber = additionInfo.dietaryFiber ?? 0
            entity.additionalInfoSugars = additionInfo.sugars ?? 0
            entity.additionalInfoPotassium = additionInfo.potassium ?? 0
        } else {
            entity.hasAdditionalInfo = false
        }

        if let totalWeight {
            entity.totalWeight = totalWeight
            entity.hasTotalWeight = true
        } else {
            entity.totalWeight = 0
            entity.hasTotalWeight = false
        }
        entity.servingMultiplier = servingMultiplier


        if let servingWeight = serving.weight {
            entity.hasServingWeight = true
            entity.servingWeight = servingWeight
        } else {
            entity.hasServingWeight = false
            entity.servingWeight = 0
        }

        entity.servingMeasure = serving.measure
        entity.servingQuantity = serving.quantity

        entity.servingsJson = servings.json()
        entity.dateUpdated = dateUpdated
        entity.brandFoodId = brandFoodId

        if let amountPer {
            entity.amountPer = amountPer
            entity.hasAmountPer = true
        } else {
            entity.hasAmountPer = false
        }

        if let barCode {
            entity.barCode = barCode
        }
    }

    static var identifierName: String {
        "id"
    }
}
