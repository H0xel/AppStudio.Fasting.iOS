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

    private let viewModel: PaywallViewModel

    init(navigator: Navigator,
         input: PaywallScreenInput,
         output: @escaping ViewOutput<PaywallScreenOutput>) {

        let router = PaywallRouter(navigator: navigator)
        let viewModel = PaywallViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        PaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
