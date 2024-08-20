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

            emptyText
            .font(.poppinsMedium(.body))
            .foregroundStyle(Color.studioGreyText)
        }
    }

    var emptyText: Text {
        let text = LocalizedStringKey.tapToUse
        let parts = text.split(separator: "%@")

        if parts.count == 1 {
            return Text(text)
        }

        if parts.count == 2 {
            return Text(parts[0]) + Text(Image.sparkles) + Text(parts[1])
        }
        return Text(text)
    }
}

private extension LocalizedStringKey {
    static let tapToUse = NSLocalizedString("FoodSearchEmptyView.title.tapToUse", comment: "")
}

private extension CGFloat {
    static let spacing: CGFloat = 20
    static let titleSpacing: CGFloat = 5
    static let emojiOffset: CGFloat = -2
}

#Preview {
    FoodSearchEmptyView()
}
