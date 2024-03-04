//  
//  FoodRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct FoodRoute: Route {

    private let viewModel: FoodViewModel

    init(navigator: Navigator,
         input: FoodInput,
         output: @escaping FoodOutputBlock) {

        let router = FoodRouter(navigator: navigator)
        let viewModel = FoodViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        FoodScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
