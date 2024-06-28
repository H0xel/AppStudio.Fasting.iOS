//
//  MealRecordView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.01.2024.
//

import SwiftUI

struct MealRecordView: View {

    let meal: Meal

    var body: some View {
        HStack(alignment: .bottom, spacing: .zero) {
            Text(meal.mealItem.mealName.isEmpty ? LocalizedStringKey.quickAdd : meal.mealItem.mealName)
                .font(.poppins(.body))
                .foregroundStyle(.accent)
                .padding(.trailing, .nameTrailingPadding)
            if !meal.isQuickAdded {
                Text("\(Int(meal.mealItem.weight)) \(String.gram)")
                    .foregroundStyle(Color.studioGreyPlaceholder)
                    .font(.poppins(.description))
            }
            Spacer()
            Text("\(Int(meal.mealItem.nutritionProfile.calories))")
                .font(.poppins(.body))
                .foregroundStyle(.accent)
                .padding(.trailing, .caloriesTrailingPadding)
            Text(.calories)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyPlaceholder)
        }
    }
}

private extension CGFloat {
    static let nameTrailingPadding: CGFloat = 4
    static let caloriesTrailingPadding: CGFloat = 6
}

private extension LocalizedStringKey {
    static let calories: LocalizedStringKey = "MealTypeView.calories"
    static let quickAdd: String = NSLocalizedString("QuickAdd.title", comment: "")
}

private extension String {
    static let gram = NSLocalizedString("Ingredient.weightLabel", comment: "g")
}

#Preview {
    MealRecordView(meal: .mock)
}
