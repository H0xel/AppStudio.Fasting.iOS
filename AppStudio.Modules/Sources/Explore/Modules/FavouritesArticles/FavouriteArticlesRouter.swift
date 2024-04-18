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
}
