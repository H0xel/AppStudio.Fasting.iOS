//  
//  HintRoute.swift
//  
//
//  Created by Denis Khlopin on 07.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct HintRoute: Route {
    let navigator: Navigator
    let input: HintInput
    let output: HintOutputBlock

    var view: AnyView {
        HintScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: HintViewModel {
        let router = HintRouter(navigator: navigator)
        let viewModel = HintViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
