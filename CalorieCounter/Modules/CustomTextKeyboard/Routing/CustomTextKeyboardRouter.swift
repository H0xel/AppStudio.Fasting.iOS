//  
//  CustomTextKeyboardRouter.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.07.2024.
//

import SwiftUI
import AppStudioNavigation

class CustomTextKeyboardRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: CustomTextKeyboardInput,
                      output: @escaping CustomTextKeyboardOutputBlock) -> Route {
        CustomTextKeyboardRoute(navigator: navigator, input: input, output: output)
    }
}
