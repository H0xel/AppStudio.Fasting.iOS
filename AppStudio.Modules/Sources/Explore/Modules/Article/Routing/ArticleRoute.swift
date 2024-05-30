//  
//  ArticleRoute.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct ArticleRoute: Route {
    let navigator: Navigator
    let input: ArticleInput
    let output: ArticleOutputBlock
    
    init(navigator: Navigator, input: ArticleInput, output: @escaping ArticleOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        ArticleScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: ArticleViewModel {
        let router = ArticleRouter(navigator: navigator)
        let viewModel = ArticleViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
