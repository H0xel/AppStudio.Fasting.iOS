//  
//  W2WLoginRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.06.2024.
//

import SwiftUI
import AppStudioNavigation

class W2WLoginRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: W2WLoginInput,
                      output: @escaping W2WLoginOutputBlock) -> Route {
        W2WLoginRoute(navigator: navigator, input: input, output: output)
    }
}
