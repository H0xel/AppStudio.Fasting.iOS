//  
//  SetupFastingRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct SetupFastingRoute: Route {

    let navigator: Navigator
    let input: SetupFastingInput
    let output: SetupFastingOutputBlock

    var view: AnyView {
        SetupFastingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: SetupFastingViewModel {
        let router = SetupFastingRouter(navigator: navigator)
        let viewModel = SetupFastingViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
