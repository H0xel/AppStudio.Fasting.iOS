//
//  CustomFoodViewData.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 16.07.2024.
//

import Foundation
import WaterCounter

let grammTitle = MealServing.gramms.measure
let mlTitle = WaterUnits.liters.unitsTitle

struct CustomFoodViewData: Equatable {
    let id: String
    var foodNameText: String
    var brandNameText: String
    var servingSize: Double
    var servingAmount: Double
    var servingName: String

    var amountPer: Double
    var calories: Double
    var fat: Double
    var carbs: Double
    var protein: Double
    var barcode: String?

    var selectedServing: MealServing
    var servings: [MealServing]

    static func ==(lhs: CustomFoodViewData, rhs: CustomFoodViewData) -> Bool {
        return lhs.foodNameText == rhs.foodNameText
        && lhs.brandNameText == rhs.brandNameText
        && lhs.servingSize == rhs.servingSize
        && lhs.servingAmount == rhs.servingAmount
        && lhs.servingName == rhs.servingName
        && lhs.amountPer == rhs.amountPer
        && lhs.calories == rhs.calories
        && lhs.fat == rhs.fat
        && lhs.carbs == rhs.carbs
        && lhs.protein == rhs.protein
        && lhs.barcode == rhs.barcode
    }
}

extension MealItem {
    init(viewData: CustomFoodViewData) {
        if viewData.selectedServing.measure == mlTitle {
            self.init(mlViewData: viewData)
        } else {
            self.init(grViewData: viewData)
        }
    }

    func duplicate(viewData: CustomFoodViewData) -> MealItem {
        if !ingredients.isEmpty {
            return duplicateComplexMealItem(viewData: viewData)
        }
        return .init(viewData: viewData)
    }
}

private extension MealItem {

    func duplicateComplexMealItem(viewData: CustomFoodViewData) -> MealItem {

        let amountPer = viewData.amountPer == 0 ? 100 : viewData.amountPer
        let servingSize = viewData.servingSize == 0 ? amountPer : viewData.servingSize

        let customServing = MealServing(weight: nil,
                                        measure: viewData.servingName,
                                        quantity: viewData.servingAmount / servingSize)
        var servings = [customServing]
        if customServing != .serving {
            servings.append(.serving)
        }

        let profile = NutritionProfile(calories: viewData.calories,
                                       proteins: viewData.protein,
                                       fats: viewData.fat,
                                       carbohydrates: viewData.carbs)
            .calculate(servingMultiplier: 1 / amountPer)
        return .init(
            id: viewData.id,
            type: .product,
            name: viewData.foodNameText,
            subTitle: viewData.brandNameText,
            brandFoodId: brandFoodId,
            notes: notes,
            ingredients: ingredients.map {
                $0.updated(value: $0.weight * (1 / amountPer),
                           serving: $0.serving)
            },
            amountPer: amountPer,
            normalizedProfile: profile,
            additionInfo: additionInfo,
            totalWeight: totalWeight,
            servingMultiplier: servingSize,
            serving: customServing,
            servings: servings,
            barCode: viewData.barcode,
            dateUpdated: .now
        )
    }

    /// For ML serving
    init(mlViewData: CustomFoodViewData) {

        let amountPer = mlViewData.amountPer == 0 ? 100 : mlViewData.amountPer
        let servingSize = mlViewData.servingSize == 0 ? amountPer : mlViewData.servingSize

        id = mlViewData.id
        type = .product
        name = mlViewData.foodNameText
        subTitle = mlViewData.brandNameText
        notes = nil
        brandFoodId = nil

        ingredients = []
        self.amountPer = amountPer
        normalizedProfile = .init(calories: mlViewData.calories,
                                  proteins: mlViewData.protein,
                                  fats: mlViewData.fat,
                                  carbohydrates: mlViewData.carbs).normalize(with: servingSize,
                                                                             amountPer: amountPer)
        additionInfo = nil
        totalWeight = nil

        let selectedServing = MealServing(weight: nil,
                                          measure: mlViewData.servingName,
                                          quantity: mlViewData.servingAmount)
        let mlServing = MealServing(weight: nil,
                                    measure: WaterUnits.liters.unitsTitle,
                                    quantity: servingSize)

        serving = selectedServing
        servingMultiplier = serving.multiplier(for: 1.0 * serving.quantity)

        var servings = [selectedServing]
        if selectedServing != mlServing {
            servings.append(mlServing)
        }
        self.servings = servings
        barCode = mlViewData.barcode
        dateUpdated = .now
    }

    /// For gr Serving
    init(grViewData: CustomFoodViewData) {

        let amountPer = grViewData.amountPer == 0 ? 100 : grViewData.amountPer
        let servingSize = grViewData.servingSize == 0 ? amountPer : grViewData.servingSize

        id = grViewData.id
        type = .product
        name = grViewData.foodNameText
        subTitle = grViewData.brandNameText
        notes = nil
        brandFoodId = nil

        ingredients = []
        self.amountPer = amountPer
        normalizedProfile = .init(calories: grViewData.calories,
                                  proteins: grViewData.protein,
                                  fats: grViewData.fat,
                                  carbohydrates: grViewData.carbs).normalize(with: amountPer)
        additionInfo = nil
        totalWeight = nil

        let selectedServing = MealServing(weight: servingSize,
                                          measure: grViewData.servingName,
                                          quantity: grViewData.servingAmount)

        serving = selectedServing
        servingMultiplier = serving.multiplier(for: 1.0 * serving.quantity)

        var servings = [selectedServing]

        if selectedServing.measure != grammTitle {
            servings.append(.gramms)
        }

        self.servings = servings
        barCode = grViewData.barcode
        dateUpdated = .now
    }
}

extension CustomFoodViewData {
    static func duplicate(mealItem: MealItem) -> CustomFoodViewData {
        if !mealItem.ingredients.isEmpty {
            return duplicateComplexMealItem(mealItem: mealItem)
        }
        if mealItem.type == .product {
            return duplicateProduct(mealItem: mealItem)
        }
        return duplicateSingleIngredientMealItem(mealItem: mealItem)
    }

    static func duplicateSingleIngredientMealItem(mealItem: MealItem) -> CustomFoodViewData {
        var nutritionProfile = mealItem.nutritionProfile
        let selectedServing = mealItem.serving
        let servingSize = (selectedServing.weight ?? selectedServing.quantity) * mealItem.servingMultiplier

        if let amountPer = mealItem.amountPer {
            nutritionProfile = nutritionProfile.calculate(servingMultiplier: amountPer / servingSize)
        }

        return .init(
            id: mealItem.id,
            foodNameText: mealItem.name,
            brandNameText: mealItem.subTitle ?? "",
            servingSize: servingSize,
            servingAmount: mealItem.serving.quantity * mealItem.servingMultiplier,
            servingName: mealItem.serving.measure,
            amountPer: mealItem.amountPer ??
            (selectedServing.weight ?? selectedServing.quantity) * mealItem.servingMultiplier,
            calories: nutritionProfile.calories,
            fat: nutritionProfile.fats,
            carbs: nutritionProfile.carbohydrates,
            protein: nutritionProfile.proteins,
            barcode: mealItem.barCode,
            selectedServing: selectedServing,
            servings: mealItem.servings
        )
    }

    static private func duplicateComplexMealItem(mealItem: MealItem) -> CustomFoodViewData {
        var nutritionProfile = mealItem.nutritionProfile
        if let amountPer = mealItem.amountPer {
            nutritionProfile = nutritionProfile.calculate(servingMultiplier: amountPer)
        }
        let servingSize = mealItem.servingMultiplier
        let customServing = mealItem.servings.first(where: { $0 != .serving })

        return .init(
            id: mealItem.id,
            foodNameText: mealItem.name,
            brandNameText: mealItem.subTitle ?? "",
            servingSize: servingSize,
            servingAmount: (customServing?.quantity ?? 1) * mealItem.servingMultiplier,
            servingName: customServing?.measure ?? MealServing.serving.measure,
            amountPer: mealItem.amountPer ?? servingSize,
            calories: nutritionProfile.calories,
            fat: nutritionProfile.fats,
            carbs: nutritionProfile.carbohydrates,
            protein: nutritionProfile.proteins,
            barcode: mealItem.barCode,
            selectedServing: .serving,
            servings: []
        )
    }

    static private func duplicateProduct(mealItem: MealItem) -> CustomFoodViewData {
        let mlServing = mealItem.servings.first(where: { $0.measure == mlTitle })
        let grammServing = mealItem.servings.first(where: { $0.measure != grammTitle })

        let servingSize = mlServing?.quantity ?? grammServing?.weight ?? 100
        let measure = mlServing?.measure ?? grammTitle

        var nutritionProfile = mealItem.nutritionProfile

        if measure == grammTitle {
            nutritionProfile = nutritionProfile.calculate(for: mealItem.amountPer ?? 100)
        } else {
            nutritionProfile = nutritionProfile.calculate(servingMultiplier: (mealItem.amountPer ?? 100) / servingSize)
        }

        return .init(
            id: mealItem.id,
            foodNameText: mealItem.name,
            brandNameText: mealItem.subTitle ?? "",
            servingSize: servingSize,
            servingAmount: mealItem.serving.quantity,
            servingName: mealItem.serving.measure,
            amountPer: mealItem.amountPer ?? 100,
            calories: nutritionProfile.calories,
            fat: nutritionProfile.fats,
            carbs: nutritionProfile.carbohydrates,
            protein: nutritionProfile.proteins,
            barcode: mealItem.barCode,
            selectedServing: mlServing ?? .gramms,
            servings: [
                .gramms,
                .init(weight: nil, measure: WaterUnits.liters.unitsTitle, quantity: 1)
            ]
        )
    }
}

extension CustomFoodViewData {
    static func initial(barcode: String? = nil) ->  CustomFoodViewData {
        .init(id: UUID().uuidString,
              foodNameText: "",
              brandNameText: "",
              servingSize: 0,
              servingAmount: 1,
              servingName: MealServing.serving.measure,
              amountPer: 0,
              calories: 0,
              fat: 0,
              carbs: 0,
              protein: 0,
              barcode: barcode,
              selectedServing: .gramms,
              servings: [
                .gramms,
                .init(weight: nil, measure: WaterUnits.liters.unitsTitle, quantity: 1)
              ])
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
