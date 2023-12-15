//  
//  PersonalizedPaywallRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct PersonalizedPaywallRoute: Route {

    private let viewModel: PersonalizedPaywallViewModel

    init(navigator: Navigator,
         input: PersonalizedPaywallInput,
         output: @escaping PersonalizedPaywallOutputBlock) {

        let router = PersonalizedPaywallRouter(navigator: navigator)
        let viewModel = PersonalizedPaywallViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        PersonalizedPaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
