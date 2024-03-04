//
//  MealTypePickerRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 21.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct MealTypePickerRoute: Route {

    let currentMealType: MealType?
    let onPick: (MealType) -> Void

    var view: AnyView {
        MealTypePickerView(currentMeal: currentMealType, onPick: onPick)
            .eraseToAnyView()
    }
}
