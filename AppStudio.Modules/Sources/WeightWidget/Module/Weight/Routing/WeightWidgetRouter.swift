//
//  WeightWidgetRouter.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioStyles

class WeightWidgetRouter: BaseRouter {
    func presentWeightUpdate(input: UpdateWeightInput, output: @escaping UpdateWeightOutputBlock) {
        let route = UpdateWeightRoute(navigator: navigator, input: input, output: output)
        present(sheet: route, detents: [.height(371)], showIndicator: true)
    }

    func presentHint() {
        let route = HintRoute(navigator: navigator,
                              input: .init(topic: .weight),
                              output: { _ in })
        present(sheet: route, detents: [.large, .fraction(2.0/3.0)], showIndicator: true)
    }
}
