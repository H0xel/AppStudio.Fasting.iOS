//
//  MealView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI

struct MealViewInput {
    let meal: MealItem
    let ingredientPlaceholders: [MealPlaceholder]
    let isTapped: Bool
    let isWeightTapped: Bool
    let tappedIngredient: Ingredient?
    let tappedWeightIngredient: Ingredient?
}

enum MealViewOutput {
    case ingredientTap(Ingredient)
    case ingredientWeightTap(Ingredient)
    case mealWeightTap
    case addIngredientsTap
    case onIngredientPlaceholderClose(String)
}

struct MealView: View {

    let input: MealViewInput
    let output: (MealViewOutput) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .top, spacing: .zero) {
                VStack(alignment: .leading, spacing: .titleSpacing) {
                    VStack(alignment: .leading, spacing: .subTitleSpacing) {
                        Text(input.meal.mealName)
                            .font(.poppinsBold(.buttonText))
                            .lineLimit(2)
                            .foregroundStyle(.accent)
                        if let subTitle = input.meal.brandSubtitle {
                            Text(subTitle)
                                .font(.poppins(.body))
                                .foregroundStyle(.accent)
                                .padding(.bottom, .subTitleSpacing)
                        }
                    }
                    MealNutritionProfileView(profile: input.meal.nutritionProfile,
                                             canShowNutritions: true)
                }
                Spacer()
                Button {
                    output(.mealWeightTap)
                } label: {
                    MealWeightView(weight: input.meal.weight, isTapped: input.isWeightTapped)
                }
            }
            .padding(.bottom, .titleBottomPadding)
            .padding(.leading, .leadingPadding)
            .padding(.trailing, .trailingPadding)

            if !input.ingredientPlaceholders.isEmpty {
                ForEach(input.ingredientPlaceholders, id: \.id) { placeholder in
                    IngredientPlaceholderView(placeholder: placeholder, onClose: {
                        output(.onIngredientPlaceholderClose(placeholder.id))
                    })
                    .padding(.leading, placeholder.notFound ? 0 : .leadingPadding)
                    .padding(.trailing, placeholder.notFound ? 0 : .trailingPadding)
                    .padding(.top, .spacing)
                }
            }

            if input.meal.ingredients.count > 1 {
                ForEach(input.meal.ingredients, id: \.self) { ingredient in
                    IngredientView(ingredient: ingredient,
                                   isWeightTapped: ingredient == input.tappedWeightIngredient) {
                        output(.ingredientWeightTap(ingredient))
                    }
                    .id(ingredient)
                    .background(.white)
                    .onTapGesture {
                        output(.ingredientTap(ingredient))
                    }
                    .padding(.vertical, ingredient == input.tappedIngredient ? .verticalPadding : .zero)
                    .padding(.leading, .leadingPadding)
                    .padding(.trailing, .trailingPadding)
                    .border(configuration: .init(
                        cornerRadius: .tappedIngredientCornerRadius,
                        color: .accent,
                        lineWidth: ingredient == input.tappedIngredient ? .borderWidth : 0)
                    )
                    .padding(.top, .spacing)
                }
            }

            if !input.isTapped {
                HStack(alignment: .center, spacing: .addButtonSpacing) {
                    Image.plus
                        .resizable()
                        .frame(width: .addButtonSmallPadding,
                               height: .addButtonSmallPadding)
                        .font(.poppinsBold(.headerL))
                        .foregroundStyle(Color.accentColor)
                        .padding(.addButtonSmallPadding)
                        .background(Color.studioGrayFillProgress)
                        .continiousCornerRadius(.cornerRadius)
                        .padding(.vertical, .addButtonSmallPadding)


                    Text(Localization.addIngredientTitle)
                        .font(.poppins(.body))

                    Spacer()
                }
                .onTapGesture {
                    output(.addIngredientsTap)
                }
                .padding(.horizontal, .addButtonHorizontalPadding)
                .padding(.top, .verticalPadding)
            }
        }
        .padding(.top, .topPadding)
        .padding(.bottom, input.meal.ingredients.count > 1 ? .bottomPadding : .verticalPadding)
        .background(.white)
        .border(configuration: .init(cornerRadius: .cornerRadius,
                                     color: .accent,
                                     lineWidth: input.isTapped ? .borderWidth : 0))
        .continiousCornerRadius(.cornerRadius)
        .animation(.borderAnimation, value: input.tappedIngredient)
        .animation(.borderAnimation, value: input.isTapped)
    }
}

private extension MealView {
    enum Localization {
        static let addIngredientTitle = NSLocalizedString("FoodLogScreen.addIngredientButtonTitle",
                                                          comment: "Add Ingredient")
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
    static let tappedIngredientCornerRadius: CGFloat = 8
    static let addButtonHorizontalPadding: CGFloat = 16
    static let addButtonSmallPadding: CGFloat = 8
    static let addButtonSpacing: CGFloat = 8
}

private extension Animation {
    static var borderAnimation: Animation {
        .easeInOut(duration: 0.15)
    }
}

#Preview {
    VStack {
        MealView(input: .init(meal: .mock, ingredientPlaceholders: [MealPlaceholder(mealText: "test")],
                              isTapped: false,
                              isWeightTapped: false,
                              tappedIngredient: .mock,
                              tappedWeightIngredient: nil),
                 output: { _ in })
        MealView(input: .init(meal: .mockWithSubTitle, ingredientPlaceholders: [],
                              isTapped: false,
                              isWeightTapped: false,
                              tappedIngredient: nil,
                              tappedWeightIngredient: nil),
                 output: { _ in })
    }
    .background(.red)
}