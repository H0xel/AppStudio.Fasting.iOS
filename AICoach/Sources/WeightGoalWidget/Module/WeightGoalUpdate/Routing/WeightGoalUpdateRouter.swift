//  
//  WeightGoalUpdateRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation

class WeightGoalUpdateRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: WeightGoalUpdateInput,
                      output: @escaping WeightGoalUpdateOutputBlock) -> Route {
        WeightGoalUpdateRoute(navigator: navigator, input: input, output: output)
    }
}
