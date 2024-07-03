//  
//  CustomKeyboardRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioNavigation

struct CustomKeyboardRoute: Route {
    let navigator: Navigator
    let input: CustomKeyboardInput
    let output: CustomKeyboardOutputBlock

    var view: AnyView {
        CustomKeyboardScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: CustomKeyboardViewModel {
        let router = CustomKeyboardRouter(navigator: navigator)
        let viewModel = CustomKeyboardViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
