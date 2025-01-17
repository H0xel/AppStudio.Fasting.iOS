//
//  HealthProgressRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import WeightWidget
import AppStudioModels
import WaterCounter

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


    func pushFastingHistory(input: FastingHistoryInput, outputBlock: @escaping FastingHistoryOutputBlock) {
        if #available(iOS 17.0, *) {
            let route = FastingHistoryRoute(navigator: navigator,
                                            input: input,
                                            output: { [weak self] output in
                switch output {
                case .close:
                    self?.dismiss()
                default:
                    outputBlock(output)
                }
            })
            navigator.push(route: route)
        }
    }

    func presentWeightHint() {
        let route = HintRoute(navigator: navigator,
                              input: .init(topic: .weight),
                              output: { _ in })
        navigator.present(sheet: route, detents: [.large, .fraction(2.0/3.0)], showIndicator: true)
    }

    func presentUpdateWeight(units: WeightUnit, output: @escaping UpdateWeightOutputBlock) {
        let route = UpdateWeightRoute(navigator: navigator,
                                      input: .init(date: .now, units: units),
                                      output: output)
        present(sheet: route, detents: [.height(371)], showIndicator: true)
    }

    func presentWaterSettings(output: @escaping WaterCounterSettingsOutputBlock) {
        let route = WaterCounterSettingsRoute(navigator: navigator, output: output)
        navigator.present(sheet: route, detents: [.height(415)], showIndicator: true)
    }

    func presentWeightProgress(weightUnits: WeightUnit, output: @escaping WeightProgressOutputBlock) {
        if #available(iOS 17.0, *) {
            let route = WeightProgressRoute(navigator: navigator,
                                            input: .init(weightUnits: weightUnits),
                                            output: output)
            present(route: route)
        }
    }
}
