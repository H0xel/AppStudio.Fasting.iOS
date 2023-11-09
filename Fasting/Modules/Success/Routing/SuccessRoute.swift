//  
//  SuccessRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI
import AppStudioNavigation

struct SuccessRoute: Route {

    private let viewModel: SuccessViewModel

    init(navigator: Navigator,
         input: SuccessInput,
         output: @escaping SuccessOutputBlock) {

        let router = SuccessRouter(navigator: navigator)
        let viewModel = SuccessViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        SuccessScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
