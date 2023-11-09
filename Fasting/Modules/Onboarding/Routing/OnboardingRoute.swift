//  
//  OnboardingRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct OnboardingRoute: Route {

    private let viewModel: OnboardingViewModel

    init(navigator: Navigator,
         input: OnboardingInput,
         output: @escaping OnboardingOutputBlock) {

        let router = OnboardingRouter(navigator: navigator)
        let viewModel = OnboardingViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        OnboardingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
