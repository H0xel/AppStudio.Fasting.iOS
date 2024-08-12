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
            Text(logType.emptyViewTitle)
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioGreyText)
                .padding(.bottom, .titleSpacing)
            Text(logType.emptyViewSutitle)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyPlaceholder)
        }
    }
}

private extension LogType {
    var emptyViewImage: Image {
        switch self {
        case .log, .history, .quickAdd, .addRecipe, .newFood:
            Image(.logItemsSuggest)
        case .food:
            Image(.customFoodSuggest)
        }
    }

    var emptyViewTitle: LocalizedStringKey {
        switch self {
        case .log, .history, .quickAdd, .addRecipe, .newFood:
            "FoodSuggestionsEmptyView.history.title"
        case .food:
            "FoodSuggestionsEmptyView.food.title"
        }
    }

    var emptyViewSutitle: LocalizedStringKey {
        switch self {
        case .log, .history, .quickAdd, .addRecipe, .newFood:
            "FoodSuggestionsEmptyView.history.subtitle"
        case .food:
            "FoodSuggestionsEmptyView.food.subtitle"
        }
    }
}

private extension LocalizedStringKey {
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
