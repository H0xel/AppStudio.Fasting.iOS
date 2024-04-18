//  
//  ArticlesRouter.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

class ArticlesRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: ArticlesInput,
                      output: @escaping ArticlesOutputBlock) -> Route {
        ArticlesRoute(navigator: navigator, input: input, output: output)
    }
}
