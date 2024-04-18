//  
//  UpdateWeightRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI
import AppStudioNavigation

class UpdateWeightRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: UpdateWeightInput,
                      output: @escaping UpdateWeightOutputBlock) -> Route {
        UpdateWeightRoute(navigator: navigator, input: input, output: output)
    }
}
