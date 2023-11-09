//  
//  ChooseFastingPlanRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct ChooseFastingPlanRoute: Route {

    private let viewModel: ChooseFastingPlanViewModel

    init(navigator: Navigator,
         input: ChooseFastingPlanInput,
         output: @escaping ChooseFastingPlanOutputBlock) {

        let router = ChooseFastingPlanRouter(navigator: navigator)
        let viewModel = ChooseFastingPlanViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        ChooseFastingPlanScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
