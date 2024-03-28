//  
//  WeightGoalWidgetRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioModels

class WeightGoalWidgetRouter: BaseRouter {
    func presentWeightUpdate(weightUnits: WeightUnit, output: @escaping WeightGoalUpdateOutputBlock) {
        let route = WeightGoalUpdateRoute(navigator: navigator,
                                          input: .init(weightUnits: weightUnits),
                                          output: output)
        present(sheet: route, detents: [.height(286)], showIndicator: true)
    }
}
