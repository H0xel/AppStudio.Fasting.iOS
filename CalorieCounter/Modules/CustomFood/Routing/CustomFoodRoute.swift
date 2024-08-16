//  
//  CustomFoodRoute.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI
import AppStudioNavigation

struct CustomFoodRoute: Route {
    let navigator: Navigator
    let input: CustomFoodInput
    let output: CustomFoodOutputBlock

    var view: AnyView {
        CustomFoodScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: CustomFoodViewModel {
        let router = CustomFoodRouter(navigator: navigator)
        let viewModel = CustomFoodViewModel(router: router, input: input, output: output)
        return viewModel
    }
}
