//  
//  ArticleRouter.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

class ArticleRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: ArticleInput,
                      output: @escaping ArticleOutputBlock) -> Route {
        ArticleRoute(navigator: navigator, input: input, output: output)
    }
}
