//  
//  ArticlesRoute.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

public struct ArticlesRoute: Route {
    let navigator: Navigator
    let input: ArticlesInput
    let output: ArticlesOutputBlock

    public init(navigator: Navigator, input: ArticlesInput, output: @escaping ArticlesOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        ArticlesScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: ArticlesViewModel {
        let router = ArticlesRouter(navigator: navigator)
        let viewModel = ArticlesViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
