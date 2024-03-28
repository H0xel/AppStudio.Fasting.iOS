//  
//  HintRoute.swift
//  
//
//  Created by Denis Khlopin on 07.03.2024.
//

import SwiftUI
import AppStudioNavigation

public struct HintRoute: Route {
    private let navigator: Navigator
    private let input: HintInput
    private let output: HintOutputBlock

    public init(navigator: Navigator, input: HintInput, output: @escaping HintOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        HintScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: HintViewModel {
        let router = HintRouter(navigator: navigator)
        let viewModel = HintViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
