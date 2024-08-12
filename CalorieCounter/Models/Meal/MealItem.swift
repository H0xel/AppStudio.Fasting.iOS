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
    let brandFoodId: String? // brand id from nutrition database
    let notes: String?

    // content of meal
    let ingredients: [MealItem]
    let amountPer: Double?
    let normalizedProfile: NutritionProfile
    let additionInfo: MealAdditionalInfo?

    // serving and weight
    let totalWeight: Double?
    /// для кейса с весом в сервинге, servingMultiplier - это коэффициент веса, т.е. чтобы узнать вес в граммах  нужно 100 * servingMultiplier
    /// для кейса без веса в сервинге, servingMultiplier - это коэффициент количества порций, определяет сколько порций в еде!
    var servingMultiplier: Double = 1.0
    /// сервинг может быть 2 типов: с весом и без веса
    ///  - с весом )     каждый сервинг в массиве servings должен иметь вес, конвертация сервингов происходит через вес в граммах
    ///  - без веса )    каждый сервинг в массиве servings равнозначем между собой, при конвертации вес не используется,
    ///             !!!мы заведомо знаем, что сервинги равны между собой!!!
    var serving: MealServing = .defaultServing
    let servings: [MealServing]
    let barCode: String?
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
        case brandFoodId
        case barCode
        case amountPer
    }

    init(id: String,
         type: MealCreationType,
         name: String,
         subTitle: String? = nil,
         brandFoodId: String? = nil,
         notes: String? = nil,
         ingredients: [MealItem] = [],
         amountPer: Double? = nil,
         normalizedProfile: NutritionProfile = .empty,
         additionInfo: MealAdditionalInfo? = nil,
         totalWeight: Double? = nil,
         servingMultiplier: Double,
         serving: MealServing = .defaultServing,
         servings: [MealServing],
         barCode: String? = nil,
         dateUpdated: Date = .now
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.subTitle = subTitle
        self.notes = notes
        self.ingredients = ingredients
        self.amountPer = amountPer
        self.normalizedProfile = normalizedProfile
        self.additionInfo = additionInfo
        self.totalWeight = totalWeight
        self.servingMultiplier = servingMultiplier
        self.serving = serving
        self.servings = servings
        self.barCode = barCode
        self.dateUpdated = dateUpdated
        self.brandFoodId = brandFoodId
    }
}

extension MealItem {


    var weight: Double {
        if ingredients.isEmpty {
            return serving.value(with: servingMultiplier)
        }
        if ingredients.count == 1 {
            return ingredients[0].weight
        }
        return servingMultiplier * serving.quantity
    }

    var servingTitle: String {
        "\(weight.withoutDecimalsIfNeeded) \(serving.units(for: weight))"
    }

    var grammsTitle: String? {
        if let gramms = serving.gramms(value: weight) {
            return "\(gramms.withoutDecimalsIfNeeded) \(MealServing.gramms.units(for: weight))"
        }
        return nil
    }

    func convertIngredientToMealItem(with ingredients: [MealItem]) -> MealItem {
        MealItem(
            id: UUID().uuidString,
            type: .chatGPT,
            name: "",
            brandFoodId: nil,
            ingredients: ingredients + [self],
            servingMultiplier: 1,
            serving: .serving,
            servings: [],
            dateUpdated: .now
        )
    }

    func updated(value: Double, serving: MealServing) -> MealItem {
        if ingredients.isEmpty {
            return updateWeight(value: value, serving: serving)
        }

        if ingredients.count == 1 {
            return ingredients[0].updateWeight(value: value, serving: serving)
        }
        let servingMultiplier = value / serving.quantity
        return updated(serving: serving, servingMultiplier: servingMultiplier, ingredients: ingredients.map {
            $0.updated(value: ($0.weight / $0.servingMultiplier) * servingMultiplier,
                       serving: $0.serving)
        })
    }

    private func updateWeight(value: Double, serving: MealServing) -> MealItem {
        .init(
            id: id,
            type: type,
            name: name,
            subTitle: subTitle,
            brandFoodId: brandFoodId,
            notes: notes,
            ingredients: ingredients,
            amountPer: amountPer,
            normalizedProfile: normalizedProfile,
            additionInfo: additionInfo,
            totalWeight: totalWeight,
            servingMultiplier: serving.multiplier(for: value),
            serving: serving,
            servings: servings,
            barCode: barCode,
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
        if type == .product {
            return name
        }
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
        if !ingredients.isEmpty {
            return ingredients.reduce(.empty) { $0 ++ $1.nutritionProfile }
        }
        if type == .product {
            let customNutrition = normalizedProfile.calculate(servingMultiplier: servingMultiplier)
            let ingredientsNutrition = ingredients.reduce(.empty) { $0 ++ $1.nutritionProfile }

            return .init(
                calories: customNutrition.calories + ingredientsNutrition.calories,
                proteins: customNutrition.proteins + ingredientsNutrition.proteins,
                fats: customNutrition.fats + ingredientsNutrition.fats,
                carbohydrates: customNutrition.carbohydrates + ingredientsNutrition.carbohydrates
            )
        }
        return normalizedProfile.calculate(servingMultiplier: servingMultiplier)
    }

    var customProductServingQuantity: Double? {
        servings[safe: 0]?.quantity
    }

    var canBeDeletedOnZeroUsage: Bool {
        if type == .chatGPT || type == .ingredient {
            return true
        }
        return false
    }

    var withReplacedEmptyId: MealItem {
        .init(id: id.isEmpty ? UUID().uuidString : id,
              type: type,
              name: name,
              subTitle: subTitle,
              brandFoodId: brandFoodId,
              notes: notes,
              ingredients: ingredients,
              amountPer: amountPer,
              normalizedProfile: normalizedProfile,
              additionInfo: additionInfo,
              totalWeight: totalWeight,
              servingMultiplier: servingMultiplier,
              serving: serving,
              servings: servings,
              barCode: barCode,
              dateUpdated: dateUpdated)
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

    func updated(id: String? = nil,
                 type: MealCreationType? = nil,
                 name: String? = nil,
                 serving: MealServing? = nil,
                 servingMultiplier: Double? = nil,
                 ingredients: [MealItem]? = nil,
                 normalizedProfile: NutritionProfile? = nil) -> MealItem {
        var isChanged = false
        if let type, type != self.type {
            isChanged = true
        }
        if let name, name != self.name {
            isChanged = true
        }
        if let ingredients, ingredients != self.ingredients {
            isChanged = true
        }
        if let id, id != self.id {
            isChanged = true
        }
        return .init(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name,
            subTitle: self.subTitle,
            brandFoodId: self.brandFoodId,
            notes: self.notes,
            ingredients: ingredients ?? self.ingredients,
            amountPer: amountPer,
            normalizedProfile: normalizedProfile ?? self.normalizedProfile,
            additionInfo: self.additionInfo,
            totalWeight: self.totalWeight,
            servingMultiplier: servingMultiplier ?? self.servingMultiplier,
            serving: serving ?? self.serving,
            servings: self.servings,
            barCode: barCode,
            dateUpdated: isChanged ? .now : self.dateUpdated
        )
    }

    func searchScore(for request: String) -> Double {
        var brandScore: Double = 1
        if let brandSubtitle {
            brandScore = calcScore(of: brandSubtitle, for: request)
        }
        let nameScore = calcScore(of: mealName, for: request)

        return max(nameScore, brandScore)
    }

    private func calcScore(of srting: String, for request: String) -> Double {
        var score: Double = 0.0
        let request = request
            .replacingOccurrences(of: " ", with: ",")
            .replacingOccurrences(of: "-", with: ",")
            .replacingOccurrences(of: ".", with: ",")
            .lowercased()

        let string = srting
            .replacingOccurrences(of: " ", with: ",")
            .replacingOccurrences(of: "-", with: ",")
            .replacingOccurrences(of: ".", with: ",")
            .lowercased()

        let requestWords = request.split(separator: ",")
            .map { String($0) }
            .filter { !$0.isEmpty }

        let words = string.split(separator: ",")
            .map { String($0) }
            .filter { !$0.isEmpty }
        let positionBonuses: [Double] = [20, 10, 5]
        var matchedWords: Double = 0

        for requestWord in requestWords {
            for (index, word) in words.enumerated() {
                if word.contains(requestWord) {
                    let matchPercentage = Double(requestWord.count) / Double(word.count) * 100.0
                    let positionBonus: Double = word.starts(with: requestWord) ? 50.0 : 0.0
                    let wordPositionBonus: Double = index < 3 ? positionBonuses[index] : 0.0
                    matchedWords += 1
                    score += matchPercentage + positionBonus + wordPositionBonus
                }
            }
        }

        if !words.isEmpty {
            score += (matchedWords / Double(words.count)) * 10.0
        }

        return score
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
