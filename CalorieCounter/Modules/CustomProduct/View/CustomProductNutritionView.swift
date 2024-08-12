//
//  CustomProductNutritionView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import SwiftUI

struct CustomProductNutritionView: View {

    let nutritionProfile: NutritionProfile

    var body: some View {
        VStack(spacing: .spacing) {
            MealNutritionProfileView(profile: nutritionProfile,
                                     canShowNutritions: true,
                                     weight: nil)
            FoodLogCalorieBudgetView(profile: nutritionProfile)
                .continiousCornerRadius(.cornerRadius)
                .border(configuration: .init(cornerRadius: .cornerRadius,
                                             color: .studioGreyStrokeFill,
                                             lineWidth: nutritionProfile.isEmpty ? .borderWidth : .zero))
                .frame(width: .width)
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let cornerRadius: CGFloat = 100
    static let borderWidth: CGFloat = 0.5
    static let width: CGFloat = 240
}

#Preview {
    CustomProductNutritionView(nutritionProfile: .mock)
}
