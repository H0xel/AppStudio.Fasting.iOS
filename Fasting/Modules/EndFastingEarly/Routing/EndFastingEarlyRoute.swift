//  
//  EndFastingEarlyRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 07.11.2023.
//

import SwiftUI
import AppStudioNavigation

struct EndFastingEarlyRoute: Route {

    let navigator: Navigator
    let input: EndFastingEarlyInput
    let output: EndFastingEarlyOutputBlock

    var view: AnyView {
        EndFastingEarlyScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: EndFastingEarlyViewModel {
        let router = EndFastingEarlyRouter(navigator: navigator)
        let viewModel = EndFastingEarlyViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
