//
//  SuggestedMealItemView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import SwiftUI
import AppStudioStyles
import Combine
import WaterCounter

struct SuggestedMealItemView: View {
    let meal: SuggestedMeal
    let searchRequestPublisher: AnyPublisher<String, Never>
    let isSelected: Bool
    let onTap: (MealItem) -> Void
    let onPlusTap: (MealItem) -> Void

    @State private var searchRequest = ""

    private var nutritionTypes: [NutritionType] {
        meal.type != .foodSearch || !meal.mealItem.nutritionProfile.isEmpty 
        ? NutritionType.allCases
        : [.calories]
    }

    var body: some View {
        HStack(spacing: .zero) {
            meal.icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .imageWidth, height: .imageWidth)
                .padding(.trailing, .imageSpacing)
            VStack(alignment: .leading, spacing: .verticalSpacing) {
                // MARK: - сделать сборку для Димы с отображением коэффицента сортировки
                // Text("Score: \(meal.score(for: searchRequest)) ")
                AttributedText(text: text)
                    .id(searchRequest)
                NutritionProfileWithWeightView(profile: meal.mealItem.nutritionProfile,
                                               weight: titleWithMeasure,
                                               nutritionTypes: nutritionTypes)
            }
            Spacer()
            Button {
                onPlusTap(meal.mealItem)
            } label: {
                if isSelected {
                    checkmark
                } else {
                    plus
                }
            }
        }
        .onReceive(searchRequestPublisher) { request in
            searchRequest = request
        }
        .onTapGesture {
            onTap(meal.mealItem)
        }
    }

    private var titleWithMeasure: String? {
        var titles = meal.mealItem.servingTitles

        guard let firstTitle = titles.first else {
            return nil
        }
        titles.removeFirst()

        if let secondTitle = titles.first {
            return "\(secondTitle), \(firstTitle)"
        }
        return firstTitle
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
        let fontName = requestWords.contains(part.lowercased())
        ? "Poppins-SemiBold"
        : "Poppins-Regular"

        let textAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: fontName, size: 13) ?? .systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor: UIColor(.studioBlackLight)
        ]
        return NSAttributedString(string: part, attributes: textAttributes)
    }

    private var requestWords: Set<String> {
        let searchRequest = searchRequest
            .replacingOccurrences(of: ",", with: " ")
            .replacingOccurrences(of: ", ", with: " ")
            .replacingOccurrences(of: ".", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .lowercased()

        return Set(searchRequest.split(separator: " ").map { String($0) })
    }

    private var parts: [String] {
        var name = meal.mealItem.nameDotBrand
        requestWords.forEach { searchWord in
            if name.contains(searchWord.capitalized) {
                name = name
                    .replacingOccurrences(
                        of: searchWord,
                        with: "***\(searchWord.capitalized)***",
                        options: [.caseInsensitive]
                    )
            } else {
                name = name
                    .replacingOccurrences(
                        of: searchWord,
                        with: "***\(searchWord)***",
                        options: [.caseInsensitive]
                    )
            }
        }
        return name.split(separator: "***")
            .map { String($0) }
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
    static let buttonWidth: CGFloat = 24
}

#Preview {
    VStack {
        SuggestedMealItemView(meal: .init(type: .favorite(MealType.breakfast),
                                          mealItem: .mock),
                              searchRequestPublisher: Just("Omelette").eraseToAnyPublisher(),
                              isSelected: true,
                              onTap: { _ in },
                              onPlusTap: { _ in })
        SuggestedMealItemView(meal: .init(type: .favorite(MealType.lunch),
                                          mealItem: .mock),
                              searchRequestPublisher: Just("Omelette").eraseToAnyPublisher(),
                              isSelected: true,
                              onTap: { _ in },
                              onPlusTap: { _ in })
        SuggestedMealItemView(meal: .init(type: .favorite(MealType.snack),
                                          mealItem: .mock),
                              searchRequestPublisher: Just("Omelette").eraseToAnyPublisher(),
                              isSelected: false,
                              onTap: { _ in },
                              onPlusTap: { _ in })
        SuggestedMealItemView(meal: .init(type: .favorite(MealType.dinner),
                                          mealItem: .mock),
                              searchRequestPublisher: Just("Omelette").eraseToAnyPublisher(),
                              isSelected: false,
                              onTap: { _ in },
                              onPlusTap: { _ in })
    }
    .padding(.horizontal, 16)
}

