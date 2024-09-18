//  
//  PeriodOnboardingDetailsRoute.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 16.09.2024.
//

import SwiftUI
import AppStudioNavigation

struct PeriodOnboardingDetailsRoute: Route {
    let navigator: Navigator
    let input: PeriodOnboardingDetailsInput
    let output: PeriodOnboardingDetailsOutputBlock

    var view: AnyView {
        PeriodOnboardingDetailsScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: PeriodOnboardingDetailsViewModel {
        let router = PeriodOnboardingDetailsRouter(navigator: navigator)
        let viewModel = PeriodOnboardingDetailsViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
