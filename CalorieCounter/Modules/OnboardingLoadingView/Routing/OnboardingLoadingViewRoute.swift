//  
//  OnboardingLoadingViewRoute.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 07.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct OnboardingLoadingViewRoute: Route {

    let navigator: Navigator
    let output: OnboardingLoadingViewOutputBlock

    var view: AnyView {
        OnboardingLoadingViewScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: OnboardingLoadingViewViewModel {
        let router = OnboardingLoadingViewRouter(navigator: navigator)
        let viewModel = OnboardingLoadingViewViewModel(output: output)
        viewModel.router = router
        return viewModel
    }
}
