//  
//  ScaleWeightHistoryRouter.swift
//  
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioModels

class ScaleWeightHistoryRouter: BaseRouter {
    func presentWeightUpdate(date: Date, weightUnits: WeightUnit, output: @escaping UpdateWeightOutputBlock) {
        let route = UpdateWeightRoute(navigator: navigator,
                                      input: .init(date: date,
                                                   units: weightUnits),
                                      output: output)
        present(sheet: route, detents: [.height(371)], showIndicator: true)
    }
}
