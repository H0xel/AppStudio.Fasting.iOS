//  
//  FastingRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct FastingRoute: Route {

    private let viewModel: FastingViewModel

    init(navigator: Navigator,
         input: FastingInput,
         output: @escaping FastingOutputBlock) {

        let router = FastingRouter(navigator: navigator)
        let viewModel = FastingViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        FastingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
