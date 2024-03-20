//
//  UsagePaywallRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation
import AppStudioServices

struct UsagePaywallRoute: Route {

    private let viewModel: PaywallViewModel

    init(navigator: Navigator,
         context: PaywallContext,
         output: @escaping ViewOutput<PaywallScreenOutput>) {

        let router = PaywallRouter(navigator: navigator)
        let viewModel = PaywallViewModel(input: .usageLimit(context: context), output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        UsageLimitPaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
