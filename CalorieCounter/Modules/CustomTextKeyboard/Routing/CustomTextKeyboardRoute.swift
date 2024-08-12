//  
//  CustomTextKeyboardRoute.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.07.2024.
//

import SwiftUI
import AppStudioNavigation

struct CustomTextKeyboardRoute: Route {
    let navigator: Navigator
    let input: CustomTextKeyboardInput
    let output: CustomTextKeyboardOutputBlock

    var view: AnyView {
        CustomTextKeyboardScreen(viewModel: viewModel)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            .eraseToAnyView()
    }

    private var viewModel: CustomTextKeyboardViewModel {
        let router = CustomTextKeyboardRouter(navigator: navigator)
        let viewModel = CustomTextKeyboardViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
