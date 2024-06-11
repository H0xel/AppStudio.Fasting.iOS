//  
//  QuickAddViewModel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//

import AppStudioNavigation
import AppStudioUI
import Combine
import Foundation

class QuickAddViewModel: BaseViewModel<QuickAddOutput> {

    var router: QuickAddRouter!

    @Published var calories: Double = 0.0
    @Published var proteins: Double = 0.0
    @Published var fats: Double = 0.0
    @Published var carbs: Double = 0.0
    @Published var foodName: String = ""
    var editedMeal: Meal?
    private let mealType: MealType
    private let dayDate: Date

    init(input: QuickAddInput, output: @escaping QuickAddOutputBlock) {
        mealType = input.mealType
        dayDate = input.dayDate
        super.init(output: output)
        fillData(meal: input.meal)
    }

    var isSaveAvailable: Bool {
        calories > 0 || proteins > 0 || fats > 0 || carbs > 0 || !foodName.isEmpty
    }

    func save() {
        if editedMeal != nil {
            saveMeal()
        } else {
            createMeal()
        }
        changeLogType(to: .log)
    }

    func changeLogType(to type: LogType) {
        output(.logType(logType: type))
    }

    private func fillData(meal: Meal?) {
        guard let meal, meal.isQuickAdded, let ingredient = meal.mealItem.ingredients.first else {
            return
        }
        calories = ingredient.normalizedProfile.calories
        proteins = ingredient.normalizedProfile.proteins
        fats = ingredient.normalizedProfile.fats
        carbs = ingredient.normalizedProfile.carbohydrates
        foodName = ingredient.name
        editedMeal = meal
    }

    private func createMeal() {
        let mealItem = MealItem.quickAdded(
            foodName: foodName,
            nutritionProfile: .init(calories: calories,
                                    proteins: proteins,
                                    fats: fats,
                                    carbohydrates: carbs)
        )
        let meal = Meal(
            id: UUID().uuidString,
            type: mealType,
            dayDate: dayDate,
            creationDate: .now,
            mealItem: mealItem,
            voting: .disabled)

        output(.created(meal))
    }

    func close() {
        output(.close)
    }

    private func saveMeal() {
        guard let meal = editedMeal else {
            return
        }
        let savedMeal = meal.copyWith(
            ingredients: [
                .init(
                    name: foodName,
                    brandTitle: nil,
                    weight: 100,
                    normalizedProfile: .init(
                        calories: calories,
                        proteins: proteins,
                        fats: fats,
                        carbohydrates: carbs
                    )
                )
            ]
        )
        output(.updated(savedMeal))
    }
}
