//
//  FoodLogTextFieldTitleView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.08.2024.
//

import SwiftUI

struct FoodLogTextFieldTitleView: View {

    let mealName: String

    var body: some View {
        HStack(spacing: .titleSpacing) {
            Text(String.newIngredientsTitle)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)

            Text(mealName)
                .font(.poppinsBold(.description))
                .lineLimit(1)
                .foregroundStyle(Color.studioGreyText)
        }
        .padding(.leading, .titleLeadingPadding)
        .padding(.bottom, .titleBottomPadding)
    }
}

private extension CGFloat {
    static let titleSpacing: CGFloat = 4
    static let titleLeadingPadding: CGFloat = 16
    static let titleBottomPadding: CGFloat = 8
}

private extension String {
    static let newIngredientsTitle = "FoodLogScreen.newIngredientsTitle".localized()
}

#Preview {
    FoodLogTextFieldTitleView(mealName: "Banana")
}
