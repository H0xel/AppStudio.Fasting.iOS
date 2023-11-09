//  
//  SetupFastingRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct SetupFastingRoute: Route {

    private let viewModel: SetupFastingViewModel

    init(navigator: Navigator,
         input: SetupFastingInput,
         output: @escaping SetupFastingOutputBlock) {

        let router = SetupFastingRouter(navigator: navigator)
        let viewModel = SetupFastingViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        SetupFastingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
