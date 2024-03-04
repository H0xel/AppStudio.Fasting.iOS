//
//  IngredientView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI

struct IngredientView: View {

    let ingredient: Ingredient
    let isWeightTapped: Bool
    let onWeightTap: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .titleSpacing) {
                Text(ingredient.nameWithBrand)
                    .font(.poppins(.body))
                    .foregroundStyle(.accent)
                HStack(spacing: .nutritionsSpacing) {
                    ForEach(NutritionType.allCases, id: \.self) { type in
                        NutritionView(amount: ingredient.nutritionProfile.amount(for: type),
                                      configuration: .placeholderSmall(type: type),
                                      bordered: false)
                    }
                }
            }
            Spacer()
            Button(action: onWeightTap) {
                MealWeightView(weight: ingredient.weight, isTapped: isWeightTapped)
            }
        }
    }
}

private extension CGFloat {
    static let titleSpacing: CGFloat = 6
    static let nutritionsSpacing: CGFloat = 16
    static let cornerRadius: CGFloat = 8
    static let borderWidth: CGFloat = 2
}

#Preview {
    VStack {
        IngredientView(ingredient: .mock, isWeightTapped: false) {}
        IngredientPlaceholderView(placeholder: .init(mealText: ""), onClose: {})
    }
}
