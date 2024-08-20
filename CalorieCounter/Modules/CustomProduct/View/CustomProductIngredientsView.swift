//
//  CustomProductIngredientsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.08.2024.
//

import SwiftUI
import AppStudioStyles

struct CustomProductIngredientsView: View {

    let ingredients: [IngredientStruct]
    let servingMultiplier: Double

    var body: some View {
        VStack(spacing: .zero) {
            ForEach(ingredients, id: \.self) { ingredient in
                DashedLine(dashPattern: [1, 2])
                    .foregroundStyle(Color.studioGreyStrokeFill)
                VStack(alignment: .leading, spacing: .verticalSpacing) {
                    HStack(spacing: .zero) {
                        Text(ingredient.name)
                        Spacer()
                        Text(servingValue(ingredient: ingredient))
                    }
                    .foregroundStyle(Color.studioBlackLight)
                    .font(.poppins(.description))
                    NutritionProfileWithWeightView(
                        profile: ingredient.nutritionProfile.calculate(servingMultiplier: servingMultiplier),
                        weight: servingWeight(ingredient: ingredient),
                        nutritionTypes: NutritionType.allCases
                    )

                }
                .padding(.vertical, .verticalPadding)
            }
            if !ingredients.isEmpty {
                DashedLine(dashPattern: [1, 2])
                    .foregroundStyle(Color.studioGreyStrokeFill)
            }
        }
    }

    private func servingValue(ingredient: IngredientStruct) -> String {
        let weight = ingredient.weight * servingMultiplier
        return "\(weight.withoutDecimalsIfNeeded) \(ingredient.serving.units(for: weight))"
    }

    private func servingWeight(ingredient: IngredientStruct) -> String {
        if let gramms = ingredient.serving.gramms(value: ingredient.weight) {
            let weight = gramms * servingMultiplier
            return "\(weight.withoutDecimalsIfNeeded) \(MealServing.gramms.measure)"
        }
        let weight = ingredient.weight * servingMultiplier
        return "\(weight.withoutDecimalsIfNeeded) \(ingredient.serving.units(for: weight))"
    }
}

private extension CGFloat {
    static let verticalSpacing: CGFloat = 4
    static let verticalPadding: CGFloat = 12
}

#Preview {
    CustomProductIngredientsView(ingredients: [.mock, .mock], servingMultiplier: 1)
        .padding(.horizontal, 16)
}
