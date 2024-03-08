//
//  HintInput.swift
//
//
//  Created by Denis Khlopin on 07.03.2024.
//

struct HintInput {
    let topic: HintTopic
}

struct HintTopic {
    let title: String
    var questionsContent: QuestionsContent?
    var bodyMassContent: BodyMassContent?
    var novaQuestionsContent: NovaQustionsContent?

    var fastingContent: FastingPhasesContent?
    var fastingInfo: ParagraphContent?
}

struct ParagraphContent {
    let title: String
    let topics: [String]
}

struct FastingPhasesContent {
    let title: String
    let phases: [FastingPhasesInfo] = [
        .init(color: .studioBlue, title: "FastingPhases.BloodSugarSlowlyRises".localized(bundle: .module)),
        .init(color: .studioPurple, title: "FastingPhases.BloodSugarIsGoingDown".localized(bundle: .module)),
        .init(color: .studioRed, title: "FastingPhases.BloodSugarReturnsToNormal".localized(bundle: .module)),
        .init(color: .studioOrange, title: "FastingPhases.FatBurning".localized(bundle: .module)),
        .init(color: .studioGreen, title: "FastingPhases.Ketosis".localized(bundle: .module)),
        .init(color: .studioSky, title: "FastingPhases.Autophagy".localized(bundle: .module)),
    ]
}

import SwiftUI
struct FastingPhasesInfo: Hashable {
    let color: Color
    let title: String
}

struct QuestionsContent {
    let title: String
    let answears: [String]
}

struct BodyMassContent {
    let title: String
    let index: BodyMassIndex
}

struct NovaQustionsContent {
    let title: String
    let questions: [String]
}

extension HintTopic {
    static func bodyMassIndexTopic(index: BodyMassIndex) -> HintTopic {
        HintTopic(
            title: "HintTopic.bmi.title".localized(bundle: .module),
            questionsContent: QuestionsContent(
                title: "HintTopic.bmi.questionsContent.title".localized(bundle: .module),
                answears: [
                    "HintTopic.bmi.questionsContent.answer1".localized(bundle: .module),
                    "HintTopic.bmi.questionsContent.answer2".localized(bundle: .module)
                ]
            ),
            bodyMassContent: BodyMassContent(
                title: "HintTopic.bmi.bodyMassContent.title".localized(bundle: .module),
                index: index
            ),
            novaQuestionsContent: NovaQustionsContent(
                title: "HintTopic.bmi.novaQustionsContent.title".localized(bundle: .module),
                questions: [
                    "HintTopic.bmi.novaQustionsContent.question1".localized(bundle: .module),
                    "HintTopic.bmi.novaQustionsContent.question2".localized(bundle: .module),
                    "HintTopic.bmi.novaQustionsContent.question3".localized(bundle: .module)
                ]
            )
        )
    }

    static func fasting() -> HintTopic {
        HintTopic(
            title: "HintTopic.fasting.title".localized(bundle: .module),
            fastingContent: FastingPhasesContent(title: "HintTopic.fasting.fastingPhasesContent.title".localized(bundle: .module)),
            fastingInfo: ParagraphContent(
                title: "HintTopic.fasting.paragraphContent.title".localized(bundle: .module),
                topics: [
                    "HintTopic.fasting.paragraphContent.topic1".localized(bundle: .module)
                ])
        )
    }
}
