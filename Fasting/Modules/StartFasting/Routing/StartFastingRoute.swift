//  
//  StartFastingRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct StartFastingRoute: Route {

    let navigator: Navigator
    let input: StartFastingInput
    let output: StartFastingOutputBlock

    var view: AnyView {
        StartFastingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: StartFastingViewModel {
        let router = StartFastingRouter(navigator: navigator)
        let viewModel = StartFastingViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}

