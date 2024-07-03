//
//  MealItem.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct MealItem: Codable, Hashable {
    let id: String
    let type: MealCreationType

    // naming
    let name: String
    let subTitle: String? // brand title
    let notes: String?

    // content of meal
    let ingredients: [MealItem]
    let normalizedProfile: NutritionProfile
    let additionInfo: MealAdditionalInfo?

    // serving and weight
    let totalWeight: Double?
    var servingMultiplier: Double = 1.0
    var serving: MealServing = .defaultServing
    let servings: [MealServing]
    let dateUpdated: Date

    enum CodingKeys: CodingKey {
        case id
        case type
        case name
        case subTitle
        case notes
        case ingredients
        case normalizedProfile
        case additionInfo

        case totalWeight
        case servingMultiplier
        case serving
        case servings
        case dateUpdated
    }

    init(id: String,
         type: MealCreationType,
         name: String,
         subTitle: String? = nil,
         notes: String? = nil,
         ingredients: [MealItem] = [],
         normalizedProfile: NutritionProfile = .empty,
         additionInfo: MealAdditionalInfo? = nil,
         totalWeight: Double? = nil,
         servingMultiplier: Double,
         serving: MealServing = .defaultServing,
         servings: [MealServing],
         dateUpdated: Date = .now
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.subTitle = subTitle
        self.notes = notes
        self.ingredients = ingredients
        self.normalizedProfile = normalizedProfile
        self.additionInfo = additionInfo
        self.totalWeight = totalWeight
        self.servingMultiplier = servingMultiplier
        self.serving = serving
        self.servings = servings
        self.dateUpdated = dateUpdated
    }
}

extension MealItem {

    var value: MealItemEditableValue {
        if ingredients.isEmpty {
            return .init(value: serving.value(with: servingMultiplier),
                         serving: serving,
                         servings: servings)
        }
        if ingredients.count == 1 {
            return ingredients[0].value
        }
        return .init(value: servingMultiplier,
                     serving: .serving,
                     servings: [])
    }

    func update(value: MealItemEditableValue) -> MealItem {
        if ingredients.isEmpty {
            return updated(value: value.value, serving: value.serving)
        }
        if ingredients.count == 1 {
            return updated(ingredients: [ingredients[0].update(value: value)])
        }
        let offset = value.value / servingMultiplier
        return updated(servingMultiplier: value.value, ingredients: ingredients.map {
            $0.updated(value: $0.value.value * offset,
                       serving: $0.serving)
        })
    }

    func updated(value: Double, serving: MealServing) -> MealItem {
        return .init(
            id: id,
            type: type,
            name: name,
            subTitle: subTitle,
            notes: notes,
            ingredients: ingredients,
            normalizedProfile: normalizedProfile,
            additionInfo: additionInfo,
            totalWeight: totalWeight,
            servingMultiplier: serving.multiplier(for: value),
            serving: serving,
            servings: servings,
            dateUpdated: .now)
    }

    static func createIngredient(name: String,
                                 brand: String? = nil,
                                 weight: Double? = nil,
                                 normalizedProfile: NutritionProfile) -> MealItem {
        var multiplier: Double = 1.0
        if let weight {
            multiplier = weight / 100
        }
        return MealItem(
            id: UUID().uuidString,
            type: .ingredient,
            name: name,
            subTitle: brand,
            normalizedProfile: normalizedProfile,
            servingMultiplier: multiplier,
            servings: .defaultServings,
            dateUpdated: .now
        )
    }

    func createIngredient(name: String,
                          brand: String? = nil,
                          weight: Double? = nil,
                          normalizedProfile: NutritionProfile) -> MealItem {
        var multiplier: Double = 1.0
        if let weight {
            multiplier = weight / 100
        }
        return MealItem(
            id: id,
            type: type,
            name: name,
            subTitle: brand ?? subTitle,
            normalizedProfile: normalizedProfile,
            servingMultiplier: multiplier,
            servings: .defaultServings,
            dateUpdated: .now
        )
    }

    static func createQuickAdd(name: String, profile: NutritionProfile) -> MealItem {
        MealItem(id: UUID().uuidString,
                 type: .quickAdd,
                 name: name,
                 normalizedProfile: profile,
                 servingMultiplier: 1.0,
                 servings: .defaultServings,
                 dateUpdated: .now)
    }

    static func createIngredient(
        name: String,
        brand: String? = nil, 
        weight: Double,
        nutritionProfile: NutritionProfile
    ) -> MealItem {

        MealItem(id: UUID().uuidString,
                 type: .ingredient,
                 name: name,
                 subTitle: brand,
                 normalizedProfile: nutritionProfile.normalize(with: weight),
                 servingMultiplier: weight / 100,
                 servings: .defaultServings,
                 dateUpdated: .now)
    }

    var nameFromIngredients: String {
        var result = ""
        for (index, ingredient) in ingredients.enumerated() {
            let separator = index == ingredients.count - 1 ? " & " : ", "
            if !result.isEmpty {
                result += separator
            }
            result += ingredient.name
        }
        return result
    }

    var brandSubtitle: String? {
        if let subTitle {
            return subTitle
        }

        if ingredients.count == 1, let ingredientBrandTitle = ingredients.first?.subTitle {
            return ingredientBrandTitle
        }

        return nil
    }

    var mealName: String {
        if name.isEmpty {
            return nameFromIngredients
        }

        if ingredients.count == 1, let ingredient = ingredients.first, !ingredient.name.isEmpty {
            if let brandTitle = ingredient.subTitle {
                return "\(ingredient.name) by \(brandTitle)"
            }
            return ingredient.name
        }
        return name
    }

    var nutritionProfile: NutritionProfile {
        if ingredients.isEmpty {
            return normalizedProfile.calculate(servingMultiplier: servingMultiplier)
        }
        return ingredients.reduce(.empty) { $0 ++ $1.nutritionProfile }
    }

    mutating func update(serving: MealServing) {
        let prevServing = self.serving
        guard let prevWeight = prevServing.weight, prevWeight > 0,
              let newWeight = serving.weight, newWeight > 0 else {
            self.serving = serving
            return
        }
        let newMultiplier = self.servingMultiplier * prevWeight / newWeight
        self.serving = serving
        self.servingMultiplier = newMultiplier
    }

    func updated(name: String? = nil,
                 servingMultiplier: Double? = nil,
                 ingredients: [MealItem]? = nil,
                 normalizedProfile: NutritionProfile? = nil) -> MealItem {
        var isChanged = false
        if let name, name != self.name {
            isChanged = true
        }
        if let ingredients, ingredients != self.ingredients {
            isChanged = true
        }
        return .init(
            id: self.id,
            type: self.type,
            name: name ?? self.name,
            subTitle: self.subTitle,
            notes: self.notes,
            ingredients: ingredients ?? self.ingredients,
            normalizedProfile: normalizedProfile ?? self.normalizedProfile,
            additionInfo: self.additionInfo,
            totalWeight: self.totalWeight,
            servingMultiplier: servingMultiplier ?? self.servingMultiplier,
            serving: self.serving,
            servings: self.servings,
            dateUpdated: isChanged ? .now : self.dateUpdated
        )
    }
}

// MARK: - Mocks
extension MealItem {
    static var mock: MealItem {
        .init(id: UUID().uuidString,
              type: .chatGPT,
              name: "Omelette with ham and cheese",
              ingredients: [.mockIngredient],
              servingMultiplier: 1.5, // 150 gramm
              servings: .defaultServings,
              dateUpdated: .now)
    }

    static var mockIngredient: MealItem {
        MealItem.createIngredient(
            name: "Egg",
            weight: 150,
            nutritionProfile: NutritionProfile(calories: 220.0,
                                               proteins: 18.0,
                                               fats: 15.0,
                                               carbohydrates: 1.0)
        )
    }

    static var mockWithSubTitle: MealItem {
        .init(id: UUID().uuidString,
              type: .chatGPT,
              name: "Omelette with ham and cheese",
              subTitle: "Omelette Brand",
              ingredients: [.mockIngredient],
              servingMultiplier: 1.5, // 150 gramm
              servings: .defaultServings,
              dateUpdated: .now)
    }

    static var mockQuickAdd: MealItem {
        .createQuickAdd(name: "", profile: .init(calories: 11, proteins: 22, fats: 33, carbohydrates: 44))
    }

    static var mockQuickAddWithTitle: MealItem {
        .createQuickAdd(name: "Quick Add Mock", profile: .init(calories: 11, proteins: 22, fats: 33, carbohydrates: 44))
    }
}

extension Array where Element == MealItem {
    var nutritionProfile: NutritionProfile {
        .init(calories: reduce(0) { $0 + $1.nutritionProfile.calories },
              proteins: reduce(0) { $0 + $1.nutritionProfile.proteins },
              fats: reduce(0) { $0 + $1.nutritionProfile.fats },
              carbohydrates: reduce(0) { $0 + $1.nutritionProfile.carbohydrates })
    }
}
