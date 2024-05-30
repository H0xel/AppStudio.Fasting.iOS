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
    private var editedMeal: Meal?

    init(meal: Meal?, output: @escaping QuickAddOutputBlock) {
        super.init(output: output)
        if let meal, meal.isQuickAdded, let ingredient = meal.mealItem.ingredients.first {
            self.calories = ingredient.normalizedProfile.calories
            self.proteins = ingredient.normalizedProfile.proteins
            self.fats = ingredient.normalizedProfile.fats
            self.carbs = ingredient.normalizedProfile.carbohydrates
            self.foodName = ingredient.name
            self.editedMeal = meal
        }
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
    }

    private func createMeal() {
        let meal = Meal(
            id: UUID().uuidString,
            type: .breakfast,
            dayDate: .now,
            creationDate: .now,
            mealItem: .init(
                id: UUID().uuidString,
                name: "",
                subTitle: nil,
                ingredients: [.init(name: foodName,
                                    brandTitle: nil,
                                    weight: 100,
                                    normalizedProfile: .init(calories: calories,
                                                             proteins: proteins,
                                                             fats: fats,
                                                             carbohydrates: carbs))],
                creationType: .quickAdd,
                dateUpdated: .now),
            voting: .disabled)

        output(.created(meal))
    }

    func clearFocus() {
        hideKeyboard()
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
