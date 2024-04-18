//  
//  WeightProgressRouter.swift
//  FastingTests
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

class WeightProgressRouter: BaseRouter {
    func presentWeightHint() {
        let route = HintRoute(navigator: navigator,
                              input: .init(topic: .weight),
                              output: { _ in })
        navigator.present(sheet: route, detents: [.large, .fraction(2.0/3.0)], showIndicator: true)
    }
}
