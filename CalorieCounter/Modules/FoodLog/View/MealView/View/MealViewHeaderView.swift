//
//  MealViewHeaderView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI

struct MealViewHeaderView: View {

    let meal: MealItem

    var body: some View {
        VStack(alignment: .leading, spacing: .subTitleSpacing) {
            Text(meal.mealName)
                .font(.poppinsBold(.buttonText))
                .lineLimit(2)
                .foregroundStyle(.accent)
            if let subTitle = meal.brandSubtitle {
                Text(subTitle)
                    .font(.poppins(.body))
                    .foregroundStyle(.accent)
                    .padding(.bottom, .subTitleSpacing)
            }
        }
    }
}

private extension CGFloat {
    static let subTitleSpacing: CGFloat = 4
}

#Preview {
    MealViewHeaderView(meal: .mock)
}
