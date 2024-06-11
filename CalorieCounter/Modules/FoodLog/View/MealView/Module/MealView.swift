//
//  MealView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI
import Combine

struct MealView: View {

    @StateObject var viewModel: MealViewViewModel

    var body: some View {
        VStack(spacing: .zero){
            VStack(spacing: .zero) {
                HStack(alignment: .top, spacing: .zero) {
                    VStack(alignment: .leading, spacing: .titleSpacing) {
                        if !viewModel.isHeaderHidden {
                            MealViewHeaderView(meal: viewModel.mealItem)
                        }
                        MealNutritionProfileView(profile: viewModel.nutritionProfile,
                                                 canShowNutritions: true)
                    }
                    Spacer()
                    if !viewModel.isQuickAdd {
                        Button(action: viewModel.weightTapped) {
                            MealWeightView(weight: viewModel.mealItem.weight, isTapped: viewModel.isWeightTapped)
                        }
                    }
                }
                .background(.white)
                .padding(.bottom, .titleBottomPadding)
                .padding(.leading, .leadingPadding)
                .padding(.trailing, .trailingPadding)

                if !viewModel.ingredientPlaceholders.isEmpty {
                    ForEach(viewModel.ingredientPlaceholders, id: \.id) { placeholder in
                        IngredientPlaceholderView(placeholder: placeholder, onClose: {
                            viewModel.closeIngredientPlaceholder(with: placeholder.id)
                        })
                        .padding(.leading, placeholder.notFound ? 0 : .leadingPadding)
                        .padding(.trailing, placeholder.notFound ? 0 : .trailingPadding)
                        .padding(.top, .spacing)
                    }
                }

                if viewModel.ingredients.count > 1 {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        IngredientView(viewModel: viewModel.ingredientViewModel(ingredient: ingredient))
                            .id(ingredient)
                            .padding(.top, .spacing)
                    }
                }

                // MARK: - BOTTOM Panel
                HStack(alignment: .center, spacing: .addButtonSpacing) {
                    if viewModel.isQuickAdd {
                        Text(Localization.quickAdd)
                            .font(.poppins(.description))
                            .foregroundStyle(Color.studioGrayText)
                    } else {
                        AddIngredientsView(onTap: viewModel.addIngredients)
                    }
                    Spacer()
                    MealViewMenuView(isPointsButtonDisabled: viewModel.isTapped) {
                        viewModel.tapMeal()
                    }
                }
                .padding(.horizontal, .addButtonHorizontalPadding)
                .padding(.top, .verticalPadding)
            }
            .padding(.top, .topPadding)
            .padding(.bottom, viewModel.ingredients.count > 1 ? .bottomPadding : .verticalPadding)
            .background(.white)
            .onTapGesture {
                viewModel.tapMeal()
            }
            .border(configuration: .init(cornerRadius: .cornerRadius,
                                         color: .accent,
                                         lineWidth: viewModel.isTapped ? .borderWidth : 0))
            .continiousCornerRadius(.cornerRadius)
            .animation(.borderAnimation, value: viewModel.isTapped)

            if viewModel.meal.voting == .notVoted {
                MealVotingView(viewModel: viewModel.votingViewModel)
            }
        }
    }
}

private extension MealView {
    enum Localization {
        static let addIngredientTitle = NSLocalizedString("FoodLogScreen.addIngredientButtonTitle",
                                                          comment: "Add Ingredient")
        static let quickAdd = NSLocalizedString("LogType.quickAdd",
                                                comment: "Quick Add")
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 20
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 20
    static let titleSpacing: CGFloat = 10
    static let spacing: CGFloat = 20
    static let subTitleSpacing: CGFloat = 4
    static let titleBottomPadding: CGFloat = 4
    static let borderWidth: CGFloat = 2
    static let verticalPadding: CGFloat = 12
    static let addButtonHorizontalPadding: CGFloat = 16
    static let addButtonSpacing: CGFloat = 8
}

extension Animation {
    static var borderAnimation: Animation {
        .easeInOut(duration: 0.15)
    }
}

#Preview {
    VStack {
        MealView(viewModel: .init(
            meal: .mock,
            mealSelectionPublisher: Just("").eraseToAnyPublisher(),
            hasSubscriptionPublisher: Just(true).eraseToAnyPublisher(),
            router: .init(navigator: .init()),
            output: { _ in }
        ))
    }
}
