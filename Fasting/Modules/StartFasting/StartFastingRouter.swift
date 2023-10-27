//  
//  StartFastingRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation

class StartFastingRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: StartFastingInput,
                      output: @escaping StartFastingOutputBlock) -> Route {
        StartFastingRoute(navigator: navigator, input: input, output: output)
    }
}
