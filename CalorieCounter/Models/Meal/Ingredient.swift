//
//  Ingredient.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct OldIngredient: Codable, Hashable {
    let name: String
    let brandTitle: String?
    let weight: Double
    let normalizedProfile: NutritionProfile

    var nameWithBrand: String {
        if let brandTitle {
            return "\(name) by \(brandTitle)"
        }
        return name
    }
}

struct IngredientStruct: Codable, Hashable {
    let id: String
    let name: String
    let brandTitle: String?
    let brandFoodId: String?
    let serving: MealServing
    let servings: [MealServing]
    let servingMultiplier: Double
    let normalizedProfile: NutritionProfile
    let dateUpdated: Date

    init(id: String,
         name: String,
         brandTitle: String?,
         brandFoodId: String?,
         serving: MealServing,
         servings: [MealServing],
         servingMultiplier: Double,
         normalizedProfile: NutritionProfile,
         dateUpdated: Date) {
        self.id = id
        self.name = name
        self.brandTitle = brandTitle
        self.brandFoodId = brandFoodId
        self.serving = serving
        self.servings = servings
        self.servingMultiplier = servingMultiplier
        self.normalizedProfile = normalizedProfile
        self.dateUpdated = dateUpdated
    }
}

extension IngredientStruct {

    init(name: String,
         brandTitle: String?,
         weight: Double?,
         normalizedProfile: NutritionProfile) {

        var multiplier: Double = 1.0
        if let weight {
            multiplier = weight / 100
        }

        self.init(id: UUID().uuidString,
                  name: name,
                  brandTitle: brandTitle,
                  brandFoodId: "",
                  serving: .defaultServing,
                  servings: .defaultServings,
                  servingMultiplier: multiplier,
                  normalizedProfile: normalizedProfile,
                  dateUpdated: .now)
    }

    init(mealItem: MealItem) {
        id = mealItem.id
        name = mealItem.name
        brandTitle = mealItem.subTitle
        brandFoodId = mealItem.brandFoodId
        serving = mealItem.serving
        servings = mealItem.servings
        servingMultiplier = mealItem.servingMultiplier
        normalizedProfile = mealItem.normalizedProfile
        dateUpdated = mealItem.dateUpdated
    }

    var servingTitle: String {
        "\(weight.withoutDecimalsIfNeeded) \(serving.units(for: weight))"
    }

    var weight: Double {
        serving.value(with: servingMultiplier)
    }

    var nutritionProfile: NutritionProfile {
        normalizedProfile.calculate(servingMultiplier: servingMultiplier)
    }

    var nameWithBrand: String {
        if let brandTitle {
            return "\(name) by \(brandTitle)"
        }
        return name
    }

    var grammsTitle: String? {
        serving.grammsTitle(weight: weight)
    }

    var mealItem: MealItem {
        MealItem(
            id: id,
            type: .ingredient,
            name: name,
            subTitle: brandTitle,
            normalizedProfile: normalizedProfile,
            servingMultiplier: servingMultiplier,
            serving: serving,
            servings: servings,
            dateUpdated: dateUpdated
        )
    }

    /// возвращает 1 или 2 заголовка, в зависимости от текущего сервинга и юнита (г или мл)
    var servingTitles: [String] {
        let defaultResult = [servingTitle]
        // для еды без ингредиентов
        let mlServing = servings.first { $0.measure == MealServing.ml.measure }
        if serving.weight != nil {
            if serving.measure == MealServing.gramms.measure {
                return [servingTitle]
            }
            if let totalValueWeight = serving.gramms(value: weight) {
                return ["\(servingTitle)",
                        "\(totalValueWeight.withoutDecimalsIfNeeded) \(MealServing.gramms.measure)"]
            }
            return defaultResult
        }

        if let mlServing {
            return serving.measure == MealServing.ml.measure
            ? defaultResult
            : ["\(servingTitle)",
               "\(serving.convert(value: weight, to: mlServing)) \(mlServing.measure)"]
        }
        return defaultResult
    }

    func updated(value: Double, serving: MealServing) -> IngredientStruct {
        IngredientStruct(
            id: id,
            name: name,
            brandTitle: brandTitle,
            brandFoodId: brandFoodId,
            serving: serving,
            servings: servings,
            servingMultiplier: serving.multiplier(for: value),
            normalizedProfile: normalizedProfile,
            dateUpdated: .now
        )
    }

    func updated(id: String? = nil,
                 name: String? = nil,
                 brandTitle: String? = nil,
                 serving: MealServing? = nil,
                 servings: [MealServing]? = nil,
                 servingMultiplier: Double? = nil,
                 normalizedProfile: NutritionProfile? = nil) -> IngredientStruct {
        IngredientStruct(
            id: id ?? self.id,
            name: name ?? self.name,
            brandTitle: brandTitle ?? self.brandTitle,
            brandFoodId: brandFoodId,
            serving: serving ?? self.serving,
            servings: servings ?? self.servings,
            servingMultiplier: servingMultiplier ?? self.servingMultiplier,
            normalizedProfile: normalizedProfile ?? self.normalizedProfile,
            dateUpdated: .now
        )
    }

    static var mock: IngredientStruct {
        IngredientStruct(
            id: UUID().uuidString,
            name: "Egg",
            brandTitle: "",
            brandFoodId: "",
            serving: .gramms,
            servings: .defaultServings,
            servingMultiplier: 1.5,
            normalizedProfile: .mock,
            dateUpdated: .now
        )
    }
}
