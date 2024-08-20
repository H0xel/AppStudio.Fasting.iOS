//
//  FoodSuggestionsEmptyView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.05.2024.
//

import SwiftUI

struct FoodSuggestionsEmptyView: View {

    let logType: LogType

    var body: some View {
        VStack(spacing: .zero) {
            logType.emptyViewImage
                .resizable()
                .frame(width: .imageWidth, height: .imageWidth)
                .padding(.bottom, .imageSpacing)
            logType.emptyViewTitleText
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioGreyText)
                .padding(.bottom, .titleSpacing)
            logType.emptyViewSubtitleText
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyPlaceholder)
        }
    }
}

private extension LogType {
    var emptyViewImage: Image {
        switch self {
        case .history, .quickAdd, .addRecipe, .newFood:
            Image(.logItemsSuggest)
        case .log:
            Image(.logFoodWhite)
        case .food:
            Image(.customFoodSuggest)
        }
    }

    var emptyViewTitleText: Text? {
        switch self {
        case .log:
            emptyLogTitle
        default:
            Text(emptyViewTitle)
        }
    }

    var emptyViewSubtitleText: Text? {
        switch self {
        case .log:
            nil
        default:
            Text(emptyViewSubtitle)
        }
    }

    private var emptyViewTitle: LocalizedStringKey {
        switch self {
        case .log:
            ""
        case .history, .quickAdd, .addRecipe, .newFood:
            "FoodSuggestionsEmptyView.history.title"
        case .food:
            "FoodSuggestionsEmptyView.food.title"
        }
    }

    private var emptyLogTitle: Text {
        let text = LocalizedStringKey.emptyLogSubtitle
        let parts = text.split(separator: "%@")

        if parts.count == 1 {
            return Text(text)
        }

        if parts.count == 2 {
            return Text(parts[0]) + Text(Image.sparkles) + Text(parts[1])
        }
        return Text(text)
    }

    private var emptyViewSubtitle: LocalizedStringKey {
        switch self {
        case .log, .history, .quickAdd, .addRecipe, .newFood:
            "FoodSuggestionsEmptyView.history.subtitle"
        case .food:
            "FoodSuggestionsEmptyView.food.subtitle"
        }
    }
}

private extension LocalizedStringKey {
    static let emptyLogSubtitle = NSLocalizedString("FoodSuggestionsEmptyView.log.subtitle", comment: "")
    static let title: LocalizedStringKey = "FoodSuggestionsEmptyView.title"
    static let subtitle: LocalizedStringKey = "FoodSuggestionsEmptyView.subtitle"
}

private extension CGFloat {
    static let imageSpacing: CGFloat = 20
    static let titleSpacing: CGFloat = 8
    static let imageWidth: CGFloat = 32
}

#Preview {
    FoodSuggestionsEmptyView(logType: .history)
}
