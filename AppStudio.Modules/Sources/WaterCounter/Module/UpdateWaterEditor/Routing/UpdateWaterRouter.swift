//  
//  UpdateWaterRouter.swift
//  
//
//  Created by Denis Khlopin on 09.04.2024.
//

import SwiftUI
import AppStudioNavigation

class UpdateWaterRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: UpdateWaterInput,
                      output: @escaping UpdateWaterOutputBlock) -> Route {
        UpdateWaterRoute(navigator: navigator, input: input, output: output)
    }
}
