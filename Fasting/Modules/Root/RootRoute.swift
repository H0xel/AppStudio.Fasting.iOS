//  
//  RootRoute.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct RootRoute: Route {

    private let viewModel: RootViewModel

    init(navigator: Navigator,
         input: RootInput,
         output: @escaping RootOutputBlock) {

        let router = RootRouter(navigator: navigator)
        let viewModel = RootViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        RootScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
