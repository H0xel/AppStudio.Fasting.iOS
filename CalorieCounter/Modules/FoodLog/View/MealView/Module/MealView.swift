//
//  MealView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI
import Combine

struct MealView: View {

    let meal: Meal
    @StateObject var viewModel: MealViewViewModel

    var body: some View {
        VStack(spacing: .zero){
            VStack(spacing: .zero) {
                HStack(alignment: .top, spacing: .zero) {
                    VStack(alignment: .leading, spacing: .titleSpacing) {
                        if !viewModel.isHeaderHidden {
                            MealViewHeaderView(meal: viewModel.mealItem)
                        }
                    }
                    Spacer()
                    if !viewModel.isQuickAdd {
                        MealWeightView(isTextSelected: $viewModel.isWeightTextSelected, 
                                       type: .text(viewModel.displayWeight),
                                       serving: viewModel.currentServing,
                                       isTapped: viewModel.isWeightTapped) {
                            viewModel.weightTapped()
                        }
                    }
                }
                .background(.white)
                .padding(.bottom, .titleBottomPadding)
                .padding(.leading, .leadingPadding)
                .padding(.trailing, .trailingPadding)

                MealNutritionProfileView(profile: viewModel.nutritionProfile,
                                         canShowNutritions: true,
                                         weight:  viewModel.canShowWeightIcon
                                         ? viewModel.mealItem.grammsTitle
                                         : nil)
                .padding(.leading, .leadingPadding)
                .aligned(.left)

                if !viewModel.ingredientPlaceholders.isEmpty {
                    ForEach(viewModel.ingredientPlaceholders, id: \.id) { placeholder in
                        IngredientPlaceholderView(placeholder: placeholder, onClose: {
                            viewModel.closeIngredientPlaceholder(with: placeholder.id)
                        })
                        .padding(.leading, placeholder.notFound ? .zero : .leadingPadding)
                        .padding(.trailing, placeholder.notFound ? .zero : .trailingPadding)
                        .padding(.top, .spacing)
                    }
                }

                if canShowIngredients {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        IngredientView(viewModel: viewModel.ingredientViewModel(ingredient: ingredient))
                            .id(ingredient)
                            .padding(.top, .ingredientSpacing)
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
                .padding(.top, .addIngridientTopPadding)
            }
            .padding(.top, .topPadding)
            .padding(.bottom, .addIngridientBottomPadding)
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
        .onChange(of: meal) { meal in
            viewModel.assignMeal(meal)
        }
    }

    var canShowIngredients: Bool {
        viewModel.ingredients.count > 1
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
    static let addIngridientBottomPadding: CGFloat = 10
    static let paddingWithOneIngridient: CGFloat = 10
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 20
    static let titleSpacing: CGFloat = 10
    static let spacing: CGFloat = 20
    static let ingredientSpacing: CGFloat = 16
    static let subTitleSpacing: CGFloat = 4
    static let titleBottomPadding: CGFloat = 4
    static let borderWidth: CGFloat = 2
    static let addIngridientTopPadding: CGFloat = 10
    static let addButtonHorizontalPadding: CGFloat = 20
    static let addButtonSpacing: CGFloat = 8
}

extension Animation {
    static var borderAnimation: Animation {
        .easeInOut(duration: 0.15)
    }
}

#Preview {
    VStack {
        MealView(meal: .mock,
                 viewModel: .init(
                    meal: .mock,
                    mealSelectionPublisher: Just("").eraseToAnyPublisher(),
                    hasSubscriptionPublisher: Just(true).eraseToAnyPublisher(),
                    selectedIngredientPublisher: Just(("", .mock)).eraseToAnyPublisher(),
                    tappedWeightMealPublisher: Just("").eraseToAnyPublisher(),
                    router: .init(navigator: .init()),
                    output: { _ in }
                 ))
    }
}
