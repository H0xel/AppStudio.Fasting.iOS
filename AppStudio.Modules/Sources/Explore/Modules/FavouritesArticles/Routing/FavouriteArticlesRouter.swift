//
//  FavouriteArticlesRouter.swift
//
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

class FavouriteArticlesRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: FavouriteArticlesInput,
                      output: @escaping FavouriteArticlesOutputBlock) -> Route {
        FavouriteArticlesRoute(navigator: navigator, input: input, output: output)
    }

    func presentArticle(_ article: Article, previewImage: Image?) {
        let route = ArticleRoute(navigator: navigator, input: .init(article: article, previewImage: previewImage), output: { [weak self] output in
            switch output {
            case .close:
                self?.navigator.dismiss()
            }
        })
        present(route: route)
    }
}
