//  
//  InActiveFastingArticleRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI
import AppStudioNavigation

class InActiveFastingArticleRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: InActiveFastingArticleInput,
                      output: @escaping InActiveFastingArticleOutputBlock) -> Route {
        InActiveFastingArticleRoute(navigator: navigator, input: input, output: output)
    }
}
