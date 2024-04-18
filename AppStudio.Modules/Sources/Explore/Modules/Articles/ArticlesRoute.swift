//  
//  ArticlesRoute.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct ArticlesRoute: Route {
    let navigator: Navigator
    let input: ArticlesInput
    let output: ArticlesOutputBlock

    var view: AnyView {
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
