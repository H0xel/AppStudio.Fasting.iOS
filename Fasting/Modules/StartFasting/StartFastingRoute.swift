//  
//  StartFastingRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct StartFastingRoute: Route {

    private let viewModel: StartFastingViewModel

    init(navigator: Navigator,
         input: StartFastingInput,
         output: @escaping StartFastingOutputBlock) {

        let router = StartFastingRouter(navigator: navigator)
        let viewModel = StartFastingViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        StartFastingScreen(viewModel: viewModel)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .eraseToAnyView()
    }
}
