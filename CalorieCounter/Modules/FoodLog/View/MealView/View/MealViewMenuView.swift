//
//  MealViewMenuView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI

struct MealViewMenuView: View {

    let isPointsButtonDisabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image.points
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .iconSize, height: .iconSize)
                .padding(.iconPadding)
                .foregroundStyle(isPointsButtonDisabled
                                 ? Color.studioGreyStrokeFill : Color.studioBlackLight)
        }
    }
}

private extension CGFloat {
    static let iconSize: CGFloat = 16
    static let iconPadding: CGFloat = 4
}

#Preview {
    MealViewMenuView(isPointsButtonDisabled: false, onTap: {})
}
