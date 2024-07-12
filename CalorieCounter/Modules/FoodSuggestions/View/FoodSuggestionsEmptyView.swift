//
//  FoodSuggestionsEmptyView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.05.2024.
//

import SwiftUI

struct FoodSuggestionsEmptyView: View {
    var body: some View {
        VStack(spacing: .zero) {
            Image(.logItemsSuggest)
                .resizable()
                .frame(width: .imageWidth, height: .imageWidth)
                .padding(.bottom, .imageSpacing)
            Text(.title)
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioGreyText)
                .padding(.bottom, .titleSpacing)
            Text(.subtitle)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyPlaceholder)
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
    FoodSuggestionsEmptyView()
}
