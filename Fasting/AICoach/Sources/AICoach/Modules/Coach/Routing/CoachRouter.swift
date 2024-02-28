//  
//  CoachRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioNavigation

class CoachRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: CoachInput,
                      output: @escaping CoachOutputBlock) -> Route {
        CoachRoute(navigator: navigator, input: input, output: output)
    }
}
