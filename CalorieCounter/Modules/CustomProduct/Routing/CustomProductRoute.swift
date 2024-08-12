//  
//  CustomProductRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import SwiftUI
import AppStudioNavigation

struct CustomProductRoute: Route {
    let navigator: Navigator
    let input: CustomProductInput
    let output: CustomProductOutputBlock

    var view: AnyView {
        CustomProductScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: CustomProductViewModel {
        let router = CustomProductRouter(navigator: navigator)
        let viewModel = CustomProductViewModel(input: input, router: router, output: output)
        return viewModel
    }
}
