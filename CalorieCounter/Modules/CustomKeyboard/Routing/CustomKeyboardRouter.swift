//  
//  CustomKeyboardRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioNavigation

class CustomKeyboardRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: CustomKeyboardInput,
                      output: @escaping CustomKeyboardOutputBlock) -> Route {
        CustomKeyboardRoute(navigator: navigator, input: input, output: output)
    }
}
