//  
//  ChooseFastingPlanRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct ChooseFastingPlanRoute: Route {

    let navigator: Navigator
    let input: ChooseFastingPlanInput
    let output: ChooseFastingPlanOutputBlock

    var view: AnyView {
        ChooseFastingPlanScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: ChooseFastingPlanViewModel {
        let router = ChooseFastingPlanRouter(navigator: navigator)
        let viewModel = ChooseFastingPlanViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
