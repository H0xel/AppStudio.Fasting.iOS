//
//  HintTopic+extensions.swift
//
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import Foundation
import AppStudioStyles

public extension HintTopic {
    static var weight: HintTopic {
        .init(
            title: "WeightWidgetHint.title".localized(bundle: .module),
            content: [
                .question(.scaleWeight),
                .question(.trueWeight),
                .question(.howToWeight),
                .question(.howOftenToWeight)
            ]
        )
    }
}

extension QuestionContent {
    static var scaleWeight: QuestionContent {
        .init(
            title: "WeightWidgetHint.scaleWeight.title".localized(bundle: .module),
            icon: .init(.scale),
            answers: [
                "WeightWidgetHint.scaleWeight.answer1".localized(bundle: .module),
                "WeightWidgetHint.scaleWeight.answer2".localized(bundle: .module)
            ]
        )
    }

    static var trueWeight: QuestionContent {
        .init(
            title: "WeightWidgetHint.trueWeight.title".localized(bundle: .module),
            icon: .init(.trueWeight),
            answers: [
                "WeightWidgetHint.trueWeight.answer1".localized(bundle: .module),
                "WeightWidgetHint.trueWeight.answer2".localized(bundle: .module)
            ]
        )
    }

    static var howToWeight: QuestionContent {
        .init(
            title: "WeightWidgetHint.howToWeight.title".localized(bundle: .module),
            icon: .init(.light),
            answers: [
                "WeightWidgetHint.howToWeight.answer1".localized(bundle: .module)
            ]
        )
    }

    static var howOftenToWeight: QuestionContent {
        .init(
            title: "WeightWidgetHint.howOftenWeight.title".localized(bundle: .module),
            icon: .init(.calendar),
            answers: [
                "WeightWidgetHint.howOftenWeight.answer1".localized(bundle: .module)
            ]
        )
    }
}
