//
//  IngredientView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI
import Combine

struct IngredientView: View {

    @StateObject var viewModel: IngredientViewModel

    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .titleSpacing) {
                Text(viewModel.ingredient.nameWithBrand)
                    .lineLimit(2)
                    .font(.poppins(.description))
                    .foregroundStyle(.accent)
                    .lineSpacing(.lineSpacing)
                HStack(spacing: .nutritionsSpacing) {
                    ForEach(NutritionType.allCases, id: \.self) { type in
                        NutritionView(amount: viewModel.ingredient.nutritionProfile.amount(for: type),
                                      configuration: .placeholderSmall(type: type),
                                      bordered: false)
                    }
                    if let titleinGramms = viewModel.ingredient.grammsTitle {
                        Group {
                            Text("|")
                            Text(titleinGramms)
                        }
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGrayPlaceholder)
                    }
                }
            }
            Spacer()
            Button(action: viewModel.weightTapped) {
                MealWeightView(type: .weight(viewModel.displayWeight),
                               serving: viewModel.displayServing,
                               isTapped: viewModel.isWeightTapped)
            }
        }
        .background(.white)
        .padding(.vertical, viewModel.isTapped ? .verticalPadding : .zero)
        .padding(.leading, .leadingPadding)
        .padding(.trailing, .trailingPadding)
        .border(configuration: .init(
            cornerRadius: .tappedIngredientCornerRadius,
            color: .accent,
            lineWidth: viewModel.isTapped ? .borderWidth : 0)
        )
        .onTapGesture {
            viewModel.ingredientTapped()
        }
        .animation(.borderAnimation, value: viewModel.state)
    }
}

private extension CGFloat {
    static let titleSpacing: CGFloat = 4
    static let nutritionsSpacing: CGFloat = 12
    static let lineSpacing: CGFloat = 3
    static let cornerRadius: CGFloat = 8
    static let borderWidth: CGFloat = 2
    static let verticalPadding: CGFloat = 12
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 12
    static let tappedIngredientCornerRadius: CGFloat = 8
}

#Preview {
    VStack {
        IngredientView(viewModel: .init(
            input: .init(ingredient: .mock,
                         router: .init(navigator: .init()),
                         statePublisher: Just(.mock).eraseToAnyPublisher(), 
                         tappedWeightIngredientPublisher: Just(.mock).eraseToAnyPublisher()),
            output: { _ in }))
        IngredientPlaceholderView(placeholder: .init(mealText: ""), onClose: {})
    }
}
