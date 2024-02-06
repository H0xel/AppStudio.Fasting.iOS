//  
//  RootRoute.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct RootRoute: Route {

    let navigator: Navigator
    let input: RootInput
    let output: RootOutputBlock

    var view: AnyView {
        RootScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: RootViewModel {
        let router = RootRouter(navigator: navigator)
        let viewModel = RootViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
