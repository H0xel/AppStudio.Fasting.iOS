//
//  FoodSearchEmptyView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.05.2024.
//

import SwiftUI
import AppStudioStyles

struct FoodSearchEmptyView: View {
    var body: some View {
        VStack(spacing: .spacing) {
            Image.sparkles
                .foregroundStyle(Color.studioBlackLight)
                .font(.title2)
            HStack(spacing: .titleSpacing) {
                Text(.tap)
                    .font(.poppinsMedium(.body)) +
                Text(" ") +
                Text(Image.sparkles) +
                Text(" ") +
                Text(.toUse)
                    .font(.poppinsMedium(.body))
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.studioGreyText)
        }
    }
}

private extension LocalizedStringKey {
    static let tap: LocalizedStringKey = "FoodSearchEmptyView.title.tap"
    static let toUse: LocalizedStringKey = "FoodSearchEmptyView.title.toUse"
}

private extension CGFloat {
    static let spacing: CGFloat = 20
    static let titleSpacing: CGFloat = 5
    static let emojiOffset: CGFloat = -2
}

#Preview {
    FoodSearchEmptyView()
}
