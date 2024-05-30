//  
//  ArticlesRouter.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

class ArticlesRouter: BaseRouter {
    func presentFavorites() {
        let route = FavouriteArticlesRoute(navigator: navigator,
                                           input: .init(),
                                           output: { _ in })
        push(route: route)
    }

    func present(article: Article, previewImage: Image?) {
        let route = ArticleRoute(navigator: navigator, input: .init(article: article, previewImage: previewImage), output: { [weak self] output in 
            switch output {
            case .close:
                self?.navigator.dismiss()
            }
        })
        present(route: route)
    }
}
