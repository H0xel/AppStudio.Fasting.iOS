//
//  SuggestedMealItemView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import SwiftUI
import AppStudioStyles

struct SuggestedMealItemView: View {

    let meal: SuggestedMeal
    let searchRequest: String
    let isSelected: Bool
    let onTap: (MealItem) -> Void

    var body: some View {
        HStack(spacing: .zero) {
            meal.icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .imageWidth, height: .imageWidth)
                .padding(.trailing, .imageSpacing)
            VStack(alignment: .leading, spacing: .verticalSpacing) {

                AttributedText(text: text)

                HStack(spacing: .nutritionsSpacing) {
                    ForEach(NutritionType.allCases, id: \.self) { type in
                        NutritionView(amount: meal.mealItem.nutritionProfile.amount(for: type),
                                      configuration: .placeholderSmall(type: type),
                                      bordered: false)
                    }
                    Group {
                        Text("|")
                        Text(meal.mealItem.weightWithUnits)
                    }
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGrayPlaceholder)
                }
            }
            Spacer()
            Button {
                onTap(meal.mealItem)
            } label: {
                if isSelected {
                    checkmark
                } else {
                    plus
                }
            }
        }
    }

    private var text: NSAttributedString {
        let textParts = parts
        let result = NSMutableAttributedString(string: "")

        for part in textParts {
            let attributedPart = attributedTextPart(part: part)
            result.append(attributedPart)
        }
        return result
    }

    private func attributedTextPart(part: String) -> NSAttributedString {
        let fontName = part.lowercased() == searchRequest.lowercased() ? "Poppins-SemiBold" : "Poppins-Regular"
        let textAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: fontName, size: 13) ?? .systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor: UIColor(.studioBlackLight)
        ]
        return NSAttributedString(string: part, attributes: textAttributes)
    }

    private var parts: [String] {
        let name = meal.mealItem.name.replacingOccurrences(
            of: searchRequest,
            with: "***\(searchRequest)***",
            options: [.caseInsensitive]
        )
        return name.split(separator: "***").enumerated().map {
            $0.0 == 0 ? .init($0.1.capitalized) : .init($0.1.lowercased())
        }
    }

    private var plus: some View {
        Circle()
            .fill(Color.studioGrayFillProgress)
            .frame(width: .buttonWidth)
            .overlay(
                Image.plus
                    .font(.footnote.weight(.semibold))
            )
    }

    private var checkmark: some View {
        Circle()
            .fill(Color.studioGreen)
            .frame(width: .buttonWidth)
            .overlay(
                Image.checkmark
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
            )
    }
}

private extension CGFloat {
    static let imageSpacing: CGFloat = 12
    static let imageWidth: CGFloat = 32
    static let verticalSpacing: CGFloat = 4
    static let nutritionsSpacing: CGFloat = 12
    static let buttonWidth: CGFloat = 24
}

#Preview {
    VStack {
        SuggestedMealItemView(meal: .init(icon: MealType.breakfast.image,
                                          mealItem: .mock),
                              searchRequest: "Omelette",
                              isSelected: true,
                              onTap: { _ in })
        SuggestedMealItemView(meal: .init(icon: MealType.lunch.image,
                                          mealItem: .mock),
                              searchRequest: "Omelette",
                              isSelected: true,
                              onTap: { _ in })
        SuggestedMealItemView(meal: .init(icon: MealType.snack.image,
                                          mealItem: .mock),
                              searchRequest: "Omelette",
                              isSelected: false,
                              onTap: { _ in })
        SuggestedMealItemView(meal: .init(icon: MealType.dinner.image,
                                          mealItem: .mock),
                              searchRequest: "Omelette",
                              isSelected: false,
                              onTap: { _ in })
    }
    .padding(.horizontal, 16)
}
