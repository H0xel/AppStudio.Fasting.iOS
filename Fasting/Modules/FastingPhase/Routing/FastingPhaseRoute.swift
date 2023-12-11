//  
//  FastingPhaseRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct FastingPhaseRoute: Route {

    private let viewModel: FastingPhaseViewModel

    init(navigator: Navigator,
         input: FastingPhaseInput,
         output: @escaping FastingPhaseOutputBlock) {

        let router = FastingPhaseRouter(navigator: navigator)
        let viewModel = FastingPhaseViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        FastingPhaseScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
