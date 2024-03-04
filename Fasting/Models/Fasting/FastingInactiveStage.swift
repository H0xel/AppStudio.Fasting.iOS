//
//  FastingInactiveStage.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI

enum FastingInActiveArticle: String, CaseIterable, Equatable {
    case howToPrepareForFasting
    case whatCanYouEatWhileFasting
    case fastingPhases
}

extension FastingInActiveArticle {
    var buttonTitle: String {
        switch self {
        case .howToPrepareForFasting:
            return NSLocalizedString("FastingInactiveStage.prepareForFasting", comment: "How to prepare for fasting?")
        case .whatCanYouEatWhileFasting:
            return NSLocalizedString("FastingInactiveStage.whatCanYouEat", comment: "What can you eat while fasting?")
        case .fastingPhases:
            return NSLocalizedString("FastingInactiveStage.fastingPhases", comment: "Fasting phases")
        }
    }

    var buttonIcon: Image? {
        switch self {
        case .fastingPhases:
            return .init(.allPhasesIcon)
        default:
            return nil
        }
    }

    var articleImage: Image? {
        switch self {
        case .howToPrepareForFasting:
            return Image(.prepareDrinks)
        case .whatCanYouEatWhileFasting:
            return Image(.eatFood)
        case .fastingPhases: return nil
        }
    }

    var description: String {
        switch self {
        case .howToPrepareForFasting:
            return NSLocalizedString("FastingInactiveStage.prepareForFasting.description", comment: "description")
        case .whatCanYouEatWhileFasting:
            return NSLocalizedString("FastingInactiveStage.whatCanYouEat.description", comment: "description")
        case .fastingPhases:
            return ""
        }
    }

    var list: [LocalizedStringKey] {
        switch self {
        case .howToPrepareForFasting:
            return [
                "InActiveFastingArticle.list.howToPrepareForFasting.1",
                "InActiveFastingArticle.list.howToPrepareForFasting.2",
                "InActiveFastingArticle.list.howToPrepareForFasting.3",
                "InActiveFastingArticle.list.howToPrepareForFasting.4",
                "InActiveFastingArticle.list.howToPrepareForFasting.5",
                "InActiveFastingArticle.list.howToPrepareForFasting.6",
                "InActiveFastingArticle.list.howToPrepareForFasting.7",
                "InActiveFastingArticle.list.howToPrepareForFasting.8"
            ]
        case .whatCanYouEatWhileFasting:
            return [
                "InActiveFastingArticle.list.whatCanYouEatWhileFasting.1",
                "InActiveFastingArticle.list.whatCanYouEatWhileFasting.2",
                "InActiveFastingArticle.list.whatCanYouEatWhileFasting.3",
                "InActiveFastingArticle.list.whatCanYouEatWhileFasting.4",
                "InActiveFastingArticle.list.whatCanYouEatWhileFasting.5"
            ]
        case .fastingPhases:
            return []
        }
    }

    static let linearGradient: LinearGradient = {
        LinearGradient(
            gradient: Gradient(colors: [
                .studioBlue,
                .studioSky,
                .studioGreen
            ]),
            startPoint: .leading, endPoint: .trailing)
    }()
}
