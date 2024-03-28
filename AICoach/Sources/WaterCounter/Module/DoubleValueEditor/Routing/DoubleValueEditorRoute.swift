//  
//  DoubleValueEditorRoute.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct DoubleValueEditorRoute: Route {
    let navigator: Navigator
    let input: DoubleValueEditorInput
    let output: DoubleValueEditorOutputBlock

    var view: AnyView {
        DoubleValueEditorScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: DoubleValueEditorViewModel {
        let router = DoubleValueEditorRouter(navigator: navigator)
        let viewModel = DoubleValueEditorViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
