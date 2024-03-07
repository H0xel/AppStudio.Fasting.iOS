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

    var viewData: [InActiveFastingListView.ViewData] {
        switch self {
        case .howToPrepareForFasting:
            return [
                .init(type: .number(1),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.1",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.1"),
                .init(type: .number(2),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.2",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.2"),
                .init(type: .number(3),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.3",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.3"),
                .init(type: .number(4),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.4",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.4"),
                .init(type: .number(5),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.5",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.5"),
                .init(type: .number(6),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.6",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.6"),
                .init(type: .number(7),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.7",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.7"),
                .init(type: .number(8),
                      title: "InActiveFastingArticle.list.howToPrepareForFasting.title.8",
                      subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.8")
            ]
        case .whatCanYouEatWhileFasting:
            return [
                .init(type: .bullet,
                      title: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.title.1",
                      subtitle: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.1"),
                .init(type: .bullet,
                      title: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.title.2",
                      subtitle: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.2"),
                .init(type: .bullet,
                      title: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.title.3",
                      subtitle: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.3"),
                .init(type: .bullet,
                      title: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.title.4",
                      subtitle: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.4"),
                .init(type: .bullet,
                      title: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.title.5",
                      subtitle: "InActiveFastingArticle.list.whatCanYouEatWhileFasting.5")
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
