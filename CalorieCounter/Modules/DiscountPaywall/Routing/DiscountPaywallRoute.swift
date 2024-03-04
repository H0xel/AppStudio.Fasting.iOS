//  
//  DiscountPaywallRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI
import AppStudioNavigation

struct DiscountPaywallRoute: Route {

    let navigator: Navigator
    let input: DiscountPaywallInput
    let output: DiscountPaywallOutputBlock

    var view: AnyView {
        DiscountPaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: DiscountPaywallViewModel {
        let router = DiscountPaywallRouter(navigator: navigator)
        let viewModel = DiscountPaywallViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
