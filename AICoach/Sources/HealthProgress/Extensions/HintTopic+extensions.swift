//
//  HintContent+extensions.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import Foundation
import AppStudioStyles

extension HintTopic {
    static func bodyMassIndexTopic(index: BodyMassIndex) -> HintTopic {
        HintTopic(
            title: "HintTopic.bmi.title".localized(bundle: .module),
            content: [.question(.bmi),
                      .contentWidthBadge(.bmi(index: index)),
                      .novaQuestion(.bmi)]
        )
    }

    static func fasting() -> HintTopic {
        HintTopic(
            title: "HintTopic.fasting.title".localized(bundle: .module),
            content: [
                .coloredDotes(.fastingPhases),
                .paragraph(.fasting)
            ]
        )
    }
}

extension ColoredDotsContent {
    static var fastingPhases: ColoredDotsContent {
        .init(
            title: "HintTopic.fasting.fastingPhasesContent.title".localized(bundle: .module),
            phases: [
                    .init(color: .studioBlue, 
                          title: "FastingPhases.BloodSugarSlowlyRises".localized(bundle: .module)),
                    .init(color: .studioPurple, 
                          title: "FastingPhases.BloodSugarIsGoingDown".localized(bundle: .module)),
                    .init(color: .studioRed, 
                          title: "FastingPhases.BloodSugarReturnsToNormal".localized(bundle: .module)),
                    .init(color: .studioOrange, 
                          title: "FastingPhases.FatBurning".localized(bundle: .module)),
                    .init(color: .studioGreen, 
                          title: "FastingPhases.Ketosis".localized(bundle: .module)),
                    .init(color: .studioSky, 
                          title: "FastingPhases.Autophagy".localized(bundle: .module)),
            ]
        )
    }
}

extension ContentWidthBadge {
    static func bmi(index: BodyMassIndex) -> ContentWidthBadge {
        ContentWidthBadge(title: "HintTopic.bmi.bodyMassContent.title".localized(bundle: .module),
                          badgeTitle: index.title,
                          badgeColor: index.color,
                          content: index.fullDescriptions)
    }
}

extension NovaQustionsContent {
    static var bmi: NovaQustionsContent {
        NovaQustionsContent(
            title: "HintTopic.bmi.novaQustionsContent.title".localized(bundle: .module), 
            icon: .coachIcon,
            questions: [
                "HintTopic.bmi.novaQustionsContent.question1".localized(bundle: .module),
                "HintTopic.bmi.novaQustionsContent.question2".localized(bundle: .module),
                "HintTopic.bmi.novaQustionsContent.question3".localized(bundle: .module)
            ]
        )
    }
}

extension ParagraphContent {

    static var fasting: ParagraphContent {
        ParagraphContent(
            title: "HintTopic.fasting.paragraphContent.title".localized(bundle: .module),
            topics: [
                "HintTopic.fasting.paragraphContent.topic1".localized(bundle: .module)
            ])
    }
}

extension QuestionContent {
    static var bmi: QuestionContent {
        QuestionContent(
            title: "HintTopic.bmi.questionsContent.title".localized(bundle: .module), 
            icon: .hintIcon,
            answers: [
                "HintTopic.bmi.questionsContent.answer1".localized(bundle: .module),
                "HintTopic.bmi.questionsContent.answer2".localized(bundle: .module)
            ]
        )
    }
}
