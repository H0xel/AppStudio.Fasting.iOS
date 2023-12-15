//  
//  OnboardingLoadingViewRoute.swift
//  Fasting
//
//  Created by Denis Khlopin on 07.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct OnboardingLoadingViewRoute: Route {

    private let viewModel: OnboardingLoadingViewViewModel

    init(navigator: Navigator,
         output: @escaping OnboardingLoadingViewOutputBlock) {

        let router = OnboardingLoadingViewRouter(navigator: navigator)
        let viewModel = OnboardingLoadingViewViewModel(output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        OnboardingLoadingViewScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
