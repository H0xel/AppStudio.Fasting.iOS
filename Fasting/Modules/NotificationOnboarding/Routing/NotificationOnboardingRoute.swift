//  
//  NotificationOnboardingRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct NotificationOnboardingRoute: Route {

    let navigator: Navigator
    let input: NotificationOnboardingInput
    let output: NotificationOnboardingOutputBlock

    var view: AnyView {
        NotificationOnboardingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: NotificationOnboardingViewModel {
        let router = NotificationOnboardingRouter(navigator: navigator)
        let viewModel = NotificationOnboardingViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
