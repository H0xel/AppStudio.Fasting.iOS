//
//  FoodLogScrollView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI

private let topSpacerId = "topSpacerId"

struct FoodLogScrollView: View {

    @ObservedObject var viewModel: FoodLogViewModel
    let isFocused: Bool

    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                Spacer(minLength: .topSpacing)
                    .id(topSpacerId)
                ForEach(viewModel.logItems, id: \.self) { logItem in
                    switch logItem {
                    case .meal(let meal):
                        MealView(input: viewModel.mealViewInput(for: meal)) { output in
                            viewModel.handle(mealViewOutput: output, meal: meal)
                        }
                        .id(meal.id)
                        .onTapGesture {
                            viewModel.setMealToDelete(meal)
                        }
                    case .placeholder(let placeholder):
                        MealPlaceholderView(text: placeholder.mealText)
                    case .notFoundBarcode(let placeholder):
                        NotFoundMealPlaceholderView {
                            viewModel.remove(placeholder: placeholder)
                        }
                    }
                }
                Spacer(minLength: .bottomSpacing)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .onReceive(viewModel.$mealSelectedState) { value in
                if case let .addIngredients(meal) = value {
                    scrollTo(meal.id, reader: reader, anchor: .top)
                    return
                }

                if let ingredient = value.ingredient {
                    scrollTo(ingredient, reader: reader)
                    return
                }

                if let meal = value.meal {
                    scrollTo(meal.id, reader: reader, anchor: .top)
                }
            }
            .onChange(of: isFocused) { isFocused in
                if isFocused, viewModel.mealSelectedState.isNotSelected {
                    scrollTo(topSpacerId, reader: reader)
                }
                viewModel.onFocusChanged(isFocused)
            }
            .animation(.bouncy, value: viewModel.logItems)
        }
    }

    private func scrollTo<ID: Hashable>(_ id: ID, reader: ScrollViewProxy, anchor: UnitPoint = .center) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear) {
                reader.scrollTo(id, anchor: anchor)
            }
        }
    }
}

private extension CGFloat {
    static let topSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 183
}

#Preview {
    FoodLogScrollView(
        viewModel: .init(
            input: .init(
                mealType: .breakfast,
                dayDate: .now,
                context: .input,
                initialMeal: [],
                hasSubscription: false,
                mealsCountInDay: 0),
            output: { _ in }
        ), isFocused: false
    )
}
