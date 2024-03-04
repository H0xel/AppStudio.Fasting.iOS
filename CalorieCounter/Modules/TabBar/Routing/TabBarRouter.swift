//  
//  TabBarRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI
import AppStudioNavigation
import Combine

class TabBarRouter: BaseRouter {

    private let foodNavigator = Navigator()
    private let profileNavigator = Navigator()

    func foodScreen(input: FoodInput,
                    output: @escaping FoodOutputBlock) -> some View {
        let route = FoodRoute(navigator: foodNavigator,
                              input: input,
                              output: output)
        return foodNavigator.initialize(route: route)
    }

    func settingsScreen(output: @escaping ProfileOutputBlock) -> some View {
        let route = ProfileRoute(navigator: profileNavigator, input: .init(), output: output)
        return profileNavigator.initialize(route: route)
    }

    func presentMealTypePicker(from tab: AppTab, onPick: @escaping (MealType) -> Void) {
        let navigator = tab == .counter ? foodNavigator : profileNavigator
        let route = MealTypePickerRoute(currentMealType: nil) { type in
            Task {
                await navigator.dismiss()
                onPick(type)
            }
        }
        navigator.present(sheet: route, detents: [.medium], showIndicator: false)
    }

    func dismissRoutes() {
        foodNavigator.popToRoot(completion: nil)
        profileNavigator.popToRoot(completion: nil)
    }
}
