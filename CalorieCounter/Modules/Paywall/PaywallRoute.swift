//
//  PaywallRoute.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 05.08.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation

struct PaywallRoute: Route {

    let navigator: Navigator
    let input: PaywallScreenInput
    let output: ViewOutput<PaywallScreenOutput>

    var view: AnyView {
        PaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: PaywallViewModel {
        let router = PaywallRouter(navigator: navigator)
        let viewModel = PaywallViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
