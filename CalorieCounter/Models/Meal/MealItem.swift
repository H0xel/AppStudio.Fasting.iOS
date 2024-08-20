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
    let ingredients: [IngredientStruct]
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
         ingredients: [IngredientStruct] = [],
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
        if ingredients.count == 1 {
            return ingredients[0].weight
        }
        return serving.value(with: servingMultiplier)
    }

    var servingTitle: String {
        "\(weight.withoutDecimalsIfNeeded) \(serving.units(for: weight))"
    }

    var grammsTitle: String? {
        serving.grammsTitle(weight: weight)
    }

    var nameDotBrand: String {
        if let brandTitle = subTitle {
            return "\(name.capitalized)  ·  \(brandTitle.capitalized )"
        }
        if name.isEmpty {
            return nameFromIngredients
        }
        return name.capitalized
    }

    func convertIngredientToMealItem(with ingredients: [IngredientStruct]) -> MealItem {
        MealItem(
            id: UUID().uuidString,
            type: .chatGPT,
            name: "",
            brandFoodId: nil,
            ingredients: ingredients + [IngredientStruct(mealItem: self)],
            servingMultiplier: 1,
            serving: .serving,
            servings: [],
            dateUpdated: .now
        )
    }

    func updated(value: Double, serving: MealServing) -> MealItem {
        let servingMultiplier = serving.multiplier(for: value)
        if ingredients.isEmpty {
            return updated(serving: serving, servingMultiplier: servingMultiplier)
        }
        if ingredients.count == 1 {
            return ingredients[0].updated(value: value, serving: serving).mealItem
        }
        return updated(serving: serving, servingMultiplier: servingMultiplier, ingredients: ingredients.map {
            $0.updated(value: $0.weight * servingMultiplier, serving: $0.serving)
        })
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

        if ingredients.count == 1, let ingredientBrandTitle = ingredients.first?.brandTitle {
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
            if let brandTitle = ingredient.brandTitle, !brandTitle.isEmpty {
                return "\(ingredient.name) by \(brandTitle)"
            }
            return ingredient.name
        }
        return name
    }

    /// возвращает 1 или 2 заголовка, в зависимости от текущего сервинга и юнита (г или мл)
    var servingTitles: [String] {
        let defaultResult = [servingTitle]
        // для еды без ингредиентов
        if ingredients.isEmpty {
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

        // для одного ингредиента
        if let ingredient = ingredients.first, ingredients.count == 1 {
            return ingredient.servingTitles
        }

        // для еды с несколькими ингредиентами
        // ищем общий вес всех ингредиентов, откидывая ингры без веса
        let totalIngredientsWeight = ingredients.reduce(into: 0.0) { partialResult, ingredient in
            let weight = ingredient.serving.gramms(value: ingredient.weight) ?? 0.0
            partialResult += weight
        }

        if totalIngredientsWeight > 0 {
            return ["\(servingTitle)",
                    "\(totalIngredientsWeight.withoutDecimalsIfNeeded) \(MealServing.gramms.measure)"]
        }
        // при необходимости можно заморочиться и сделать подсчет мл для ингредиентов
        return defaultResult
    }

    var nutritionProfile: NutritionProfile {
        if ingredients.isEmpty {
            return normalizedProfile.calculate(servingMultiplier: servingMultiplier)
        }
        return ingredients.reduce(.empty) { $0 ++ $1.nutritionProfile }
    }

    func updated(id: String? = nil,
                 type: MealCreationType? = nil,
                 name: String? = nil,
                 serving: MealServing? = nil,
                 servingMultiplier: Double? = nil,
                 ingredients: [IngredientStruct]? = nil,
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
              ingredients: [.mock],
              servingMultiplier: 1.5, // 150 gramm
              servings: .defaultServings,
              dateUpdated: .now)
    }

    static var mockWithSubTitle: MealItem {
        .init(id: UUID().uuidString,
              type: .chatGPT,
              name: "Omelette with ham and cheese",
              subTitle: "Omelette Brand",
              ingredients: [.mock],
              servingMultiplier: 1.5, // 150 gramm
              servings: .defaultServings,
              dateUpdated: .now)
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
