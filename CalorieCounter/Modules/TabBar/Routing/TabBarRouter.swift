//  
//  TabBarRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI
import AppStudioNavigation
import Combine
import AICoach

class TabBarRouter: BaseRouter {

    private let foodNavigator = Navigator()
    private let coachNavigator = Navigator()

    func foodScreen(input: FoodInput,
                    output: @escaping FoodOutputBlock) -> some View {
        let route = FoodRoute(navigator: foodNavigator,
                              input: input,
                              output: output)
        return foodNavigator.initialize(route: route)
    }

    func coachScreen(nextMessagePublisher: AnyPublisher<String, Never>,
                     output: @escaping CoachOutputBlock) -> some View {
        let route = CoachRoute(navigator: coachNavigator,
                               input: .init(constants: .counterConstants,
                                            suggestionTypes: [.general],
                                            nextMessagePublisher: nextMessagePublisher,
                                            isMonetizationExpAvailable: Just(false).eraseToAnyPublisher()),
                               output: output)
        return coachNavigator.initialize(route: route)
    }

    func presentMealTypePicker(from tab: AppTab, onPick: @escaping (MealType) -> Void) {
        let navigator = tab == .counter ? foodNavigator : coachNavigator
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
        coachNavigator.popToRoot(completion: nil)
    }
}
