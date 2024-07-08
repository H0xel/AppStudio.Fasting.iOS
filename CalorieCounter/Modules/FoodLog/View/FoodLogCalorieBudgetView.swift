//
//  FoodLogCalorieBudgetView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.05.2024.
//

import SwiftUI

struct FoodLogCalorieBudgetView: View {

    let profile: NutritionProfile

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                Color.studioGreen
                    .frame(width: geometry.size.width * fatProportion)
                Color.studioBlue
                    .frame(width: geometry.size.width * carbsProportion)
                Color.studioOrange
                    .frame(width: geometry.size.width * proteinProportion)
            }
        }
        .frame(height: .height)
    }

    var proteinProportion: CGFloat {
        max(0, profile.proteins * NutritionProfileContent.protein.caloriesPerGramm / caloriesSum)
    }

    var fatProportion: CGFloat {
        max(0, profile.fats * NutritionProfileContent.fat.caloriesPerGramm / caloriesSum)
    }

    var carbsProportion: CGFloat {
        max(0, profile.carbohydrates * NutritionProfileContent.carbohydrates.caloriesPerGramm / caloriesSum)
    }

    var caloriesSum: CGFloat {
        profile.carbohydrates * NutritionProfileContent.carbohydrates.caloriesPerGramm +
        profile.fats * NutritionProfileContent.fat.caloriesPerGramm +
        profile.proteins * NutritionProfileContent.protein.caloriesPerGramm
    }
}

private extension CGFloat {
    static let height: CGFloat = 6
}

#Preview {
    FoodLogCalorieBudgetView(profile: .mock)
}
