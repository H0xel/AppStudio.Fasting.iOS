//  
//  FastingPhaseRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct FastingPhaseRoute: Route {

    let navigator: Navigator
    let input: FastingPhaseInput
    let output: FastingPhaseOutputBlock

    var view: AnyView {
        FastingPhaseScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: FastingPhaseViewModel {
        let router = FastingPhaseRouter(navigator: navigator)
        let viewModel = FastingPhaseViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
