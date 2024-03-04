//  
//  PersonalizedPaywallRoute.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct PersonalizedPaywallRoute: Route {

    let navigator: Navigator
    let input: PersonalizedPaywallInput
    let output: PersonalizedPaywallOutputBlock

    var view: AnyView {
        PersonalizedPaywallScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: PersonalizedPaywallViewModel {
        let router = PersonalizedPaywallRouter(navigator: navigator)
        let viewModel = PersonalizedPaywallViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
