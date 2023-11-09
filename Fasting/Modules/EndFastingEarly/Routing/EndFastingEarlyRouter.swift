//  
//  EndFastingEarlyRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 07.11.2023.
//

import SwiftUI
import AppStudioNavigation

class EndFastingEarlyRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: EndFastingEarlyInput,
                      output: @escaping EndFastingEarlyOutputBlock) -> Route {
        EndFastingEarlyRoute(navigator: navigator, input: input, output: output)
    }
}
