//  
//  ComboBoxEditorRoute.swift
//  
//
//  Created by Denis Khlopin on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct ComboBoxEditorRoute: Route {
    let navigator: Navigator
    let input: ComboBoxEditorInput
    let output: ComboBoxEditorOutputBlock

    var view: AnyView {
        ComboBoxEditorScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: ComboBoxEditorViewModel {
        let router = ComboBoxEditorRouter(navigator: navigator)
        let viewModel = ComboBoxEditorViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
