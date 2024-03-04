//  
//  FoodLogRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct FoodLogRoute: Route {

    let navigator: Navigator
    let input: FoodLogInput
    let output: FoodLogOutputBlock

    var view: AnyView {
        FoodLogScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: FoodLogViewModel {
        let router = FoodLogRouter(navigator: navigator)
        let viewModel = FoodLogViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
