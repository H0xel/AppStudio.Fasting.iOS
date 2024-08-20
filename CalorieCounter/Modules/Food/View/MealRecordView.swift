//
//  MealRecordView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.01.2024.
//

import SwiftUI
import AppStudioStyles

struct MealRecordView: View {

    let meal: Meal

    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            AttributedText(text: text, useDynamicHeight: false)
            Spacer()
            HStack(alignment: .center, spacing: .zero) {
                Text("\(Int(meal.mealItem.nutritionProfile.calories))")
                    .font(.poppins(.body))
                    .foregroundStyle(.accent)
                    .padding(.trailing, .caloriesTrailingPadding)
                Text(.calories)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyPlaceholder)
            }
            .offset(y: .offset)
        }
    }

    private var text: NSAttributedString {
        let result = NSMutableAttributedString(string: "")
        let mealName = meal.mealItem.mealName.isEmpty ? String.quickAdd : meal.mealItem.mealName
        let name = attributedTextPart(part: mealName,
                                      color: .studioBlackLight,
                                      fontSize: 15)
        result.append(name)
        if !meal.isQuickAdded {
            let itemServingTitle = meal.mealItem.servingTitles[0]
            let servingTitle = attributedTextPart(part: "   \(itemServingTitle)",
                                                  color: .studioGreyPlaceholder,
                                                  fontSize: 13)
            result.append(servingTitle)
        }
        return result
    }

    private func attributedTextPart(part: String, color: Color, fontSize: CGFloat) -> NSAttributedString {
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: fontSize) ?? .systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(color)
        ]
        return NSAttributedString(string: part, attributes: textAttributes)
    }
}

private extension CGFloat {
    static let nameTrailingPadding: CGFloat = 4
    static let caloriesTrailingPadding: CGFloat = 6
    static let offset: CGFloat = 3
}

private extension LocalizedStringKey {
    static let calories: LocalizedStringKey = "MealTypeView.calories"
}

private extension String {
    static let quickAdd = "QuickAdd.title".localized()
    static let gram = NSLocalizedString("Ingredient.weightLabel", comment: "g")
}

#Preview {
    MealRecordView(meal: .mock)
}
