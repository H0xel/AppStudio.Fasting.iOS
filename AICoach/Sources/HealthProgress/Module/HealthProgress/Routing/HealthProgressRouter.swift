//
//  HealthProgressRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI
import AppStudioNavigation

class HealthProgressRouter: BaseRouter {
    func presentBodyMassIndexHint(bodyMassIndex: BodyMassIndex,  onQuestion: @escaping (String) -> Void) {
        let route = HintRoute(
            navigator: navigator,
            input: HintInput(topic: .bodyMassIndexTopic(index: bodyMassIndex))) { [weak self] output in
                switch output {
                case .novaQuestion(let question):
                    self?.navigator.dismiss()
                    onQuestion(question)
                }
            }
        navigator.present(sheet: route, detents: [.large, .fraction(2.0/3.0)], showIndicator: true)
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

}
