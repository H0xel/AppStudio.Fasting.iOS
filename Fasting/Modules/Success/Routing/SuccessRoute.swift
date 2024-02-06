//  
//  SuccessRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI
import AppStudioNavigation

struct SuccessRoute: Route {

    let navigator: Navigator
    let input: SuccessInput
    let output: SuccessOutputBlock

    var view: AnyView {
        SuccessScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: SuccessViewModel {
        let router = SuccessRouter(navigator: navigator)
        let viewModel = SuccessViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
