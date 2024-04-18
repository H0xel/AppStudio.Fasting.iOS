//  
//  RateAppRouter.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import SwiftUI
import AppStudioNavigation

class RateAppRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: RateAppInput,
                      output: @escaping RateAppOutputBlock) -> Route {
        RateAppRoute(navigator: navigator, input: input, output: output)
    }
}
