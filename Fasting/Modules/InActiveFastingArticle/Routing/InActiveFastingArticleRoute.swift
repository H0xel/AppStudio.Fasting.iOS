//  
//  InActiveFastingArticleRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct InActiveFastingArticleRoute: Route {

    private let viewModel: InActiveFastingArticleViewModel

    init(navigator: Navigator,
         input: InActiveFastingArticleInput,
         output: @escaping InActiveFastingArticleOutputBlock) {

        let router = InActiveFastingArticleRouter(navigator: navigator)
        let viewModel = InActiveFastingArticleViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        InActiveFastingArticleScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
