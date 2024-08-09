//  
//  TrialPaywallRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 05.08.2024.
//

import SwiftUI
import AppStudioNavigation

struct TrialPaywallRoute: Route {
    let navigator: Navigator
    let input: TrialPaywallInput
    let output: TrialPaywallOutputBlock

    var view: AnyView {
        TrialPaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: TrialPaywallViewModel {
        let router = TrialPaywallRouter(navigator: navigator)
        let viewModel = TrialPaywallViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
