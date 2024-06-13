//  
//  W2WLoginRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct W2WLoginRoute: Route {
    let navigator: Navigator
    let input: W2WLoginInput
    let output: W2WLoginOutputBlock

    var view: AnyView {
        W2WLoginScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: W2WLoginViewModel {
        let router = W2WLoginRouter(navigator: navigator)
        let viewModel = W2WLoginViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
