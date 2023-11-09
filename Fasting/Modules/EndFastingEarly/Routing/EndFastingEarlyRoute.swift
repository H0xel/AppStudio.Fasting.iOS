//  
//  EndFastingEarlyRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 07.11.2023.
//

import SwiftUI
import AppStudioNavigation

struct EndFastingEarlyRoute: Route {

    private let viewModel: EndFastingEarlyViewModel

    init(navigator: Navigator,
         input: EndFastingEarlyInput,
         output: @escaping EndFastingEarlyOutputBlock) {

        let router = EndFastingEarlyRouter(navigator: navigator)
        let viewModel = EndFastingEarlyViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        EndFastingEarlyScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
