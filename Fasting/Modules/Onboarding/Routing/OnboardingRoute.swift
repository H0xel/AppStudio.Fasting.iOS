//  
//  OnboardingRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct OnboardingRoute: Route {

    let navigator: Navigator
    let input: OnboardingInput
    let output: OnboardingOutputBlock

    var view: AnyView {
        OnboardingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: OnboardingViewModel {
        let router = OnboardingRouter(navigator: navigator)
        let viewModel = OnboardingViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
