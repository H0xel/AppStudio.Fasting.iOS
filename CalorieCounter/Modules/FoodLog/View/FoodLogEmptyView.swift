//
//  FoodLogEmptyView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI

struct FoodLogEmptyView: View {

    let type: MealType

    var body: some View {
        VStack(spacing: .spacing) {
            type.image
                .resizable()
                .frame(width: .imageWidth, height: .imageHeight)
            Text(title)
                .font(.poppins(.body))
                .foregroundStyle(Color.studioGreyPlaceholder)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, .horizontalPadding)
    }

    private var title: String {
        "FoodLogScreen.emptyViewTitle.\(type.rawValue)".localized()
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 32
    static let horizontalPadding: CGFloat = 64
    static let imageWidth: CGFloat = 100
    static let imageHeight: CGFloat = 80
}

#Preview {
    FoodLogEmptyView(type: .breakfast)
}
