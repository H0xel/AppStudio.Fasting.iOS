//  
//  QuickAddRouter.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//

import SwiftUI
import AppStudioNavigation

class QuickAddRouter: BaseRouter {
    static func route(navigator: Navigator,
                      meal: Meal?,
                      output: @escaping QuickAddOutputBlock) -> Route {
        QuickAddRoute(navigator: navigator, meal: meal, output: output)
    }
}
