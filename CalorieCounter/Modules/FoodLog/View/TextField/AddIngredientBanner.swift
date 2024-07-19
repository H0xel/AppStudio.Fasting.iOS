//
//  AddIngredientBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioNavigation
import Combine

struct AddIngredientBanner: Banner {

    let mealPublisher: AnyPublisher<Meal, Never>
    let output: (AddIngredientOutput) -> Void

    var view: AnyView {
        AddIngredientTextField(mealPublisher: mealPublisher, output: output)
            .transition(.asymmetric(insertion: .identity, removal: .push(from: .top)))
            .eraseToAnyView()
    }
}
