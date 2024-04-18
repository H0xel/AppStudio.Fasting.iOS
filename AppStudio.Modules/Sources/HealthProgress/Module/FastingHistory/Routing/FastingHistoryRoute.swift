//  
//  FastingHistoryRoute.swift
//  
//
//  Created by Denis Khlopin on 12.03.2024.
//

import SwiftUI
import AppStudioNavigation

@available(iOS 17.0, *)
struct FastingHistoryRoute: Route {
    let navigator: Navigator
    let input: FastingHistoryInput
    let output: FastingHistoryOutputBlock

    var view: AnyView {
        FastingHistoryScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: FastingHistoryViewModel {
        let router = FastingHistoryRouter(navigator: navigator)
        let viewModel = FastingHistoryViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
