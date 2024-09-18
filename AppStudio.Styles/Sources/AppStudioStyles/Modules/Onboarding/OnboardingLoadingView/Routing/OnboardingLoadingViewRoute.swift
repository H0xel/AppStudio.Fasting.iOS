//  
//  OnboardingLoadingViewRoute.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 07.12.2023.
//

import SwiftUI
import AppStudioNavigation

public struct OnboardingLoadingViewRoute: Route {

    public let navigator: Navigator
    public let output: OnboardingLoadingViewOutputBlock

    public init(navigator: Navigator, output: @escaping OnboardingLoadingViewOutputBlock) {
        self.navigator = navigator
        self.output = output
    }

    public var view: AnyView {
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
