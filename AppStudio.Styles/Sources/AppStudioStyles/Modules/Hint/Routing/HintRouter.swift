//  
//  HintRouter.swift
//  
//
//  Created by Denis Khlopin on 07.03.2024.
//

import SwiftUI
import AppStudioNavigation

class HintRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: HintInput,
                      output: @escaping HintOutputBlock) -> Route {
        HintRoute(navigator: navigator, input: input, output: output)
    }
}
