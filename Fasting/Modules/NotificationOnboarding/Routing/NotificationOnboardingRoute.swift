//  
//  NotificationOnboardingRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct NotificationOnboardingRoute: Route {

    private let viewModel: NotificationOnboardingViewModel

    init(navigator: Navigator,
         input: NotificationOnboardingInput,
         output: @escaping NotificationOnboardingOutputBlock) {

        let router = NotificationOnboardingRouter(navigator: navigator)
        let viewModel = NotificationOnboardingViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        NotificationOnboardingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
