//  
//  MultiplePaywallRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 11.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct MultiplePaywallRoute: Route {
    let navigator: Navigator
    let input: MultiplePaywallInput
    let output: MultiplePaywallOutputBlock

    var view: AnyView {
        MultiplePaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: MultiplePaywallViewModel {
        let router = MultiplePaywallRouter(navigator: navigator)
        let viewModel = MultiplePaywallViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
