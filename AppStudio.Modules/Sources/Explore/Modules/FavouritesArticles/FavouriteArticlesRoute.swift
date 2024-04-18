//  
//  FavouriteArticlesRoute.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct FavouriteArticlesRoute: Route {
    let navigator: Navigator
    let input: FavouriteArticlesInput
    let output: FavouriteArticlesOutputBlock

    var view: AnyView {
        FavouriteArticlesScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: FavouriteArticlesViewModel {
        let router = FavouriteArticlesRouter(navigator: navigator)
        let viewModel = FavouriteArticlesViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
