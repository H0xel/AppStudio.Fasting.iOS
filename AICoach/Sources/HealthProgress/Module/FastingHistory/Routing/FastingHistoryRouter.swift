//  
//  FastingHistoryRouter.swift
//  
//
//  Created by Denis Khlopin on 12.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import WaterCounter

@available(iOS 17.0, *)
class FastingHistoryRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: FastingHistoryInput,
                      output: @escaping FastingHistoryOutputBlock) -> Route {
        FastingHistoryRoute(navigator: navigator, input: input, output: output)
    }

    func presentFastingHint(onQuestion: @escaping (String) -> Void) {
        let route = HintRoute(
            navigator: navigator,
            input: HintInput(topic: .fasting())) { [weak self] output in
                switch output {
                case .novaQuestion(let question):
                    self?.navigator.dismiss()
                    onQuestion(question)
                }
            }
        navigator.present(sheet: route, detents: [.large, .fraction(2.0/3.0)], showIndicator: true)
    }

    func presentUpdateWaterEditor(input: UpdateWaterInput, output: @escaping UpdateWaterOutputBlock) {
        let route = UpdateWaterRoute(navigator: navigator, input: input, output: output)

        navigator.present(sheet: route, detents: [.height(400)], showIndicator: true)
    }
}
