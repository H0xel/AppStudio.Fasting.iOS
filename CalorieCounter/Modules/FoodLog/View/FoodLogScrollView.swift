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

    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                Spacer(minLength: .topSpacing)
                    .id(topSpacerId)
                LazyVStack(spacing: .spacing) {
                    ForEach(viewModel.logItems, id: \.id) { logItem in
                        switch logItem {
                        case .meal(let meal):
                            MealView(viewModel: viewModel.mealViewModel(meal: meal))
                                .id(meal)
                                .id(meal.id)
                        case .placeholder(let placeholder):
                            MealPlaceholderView(text: placeholder.mealText)
                        case .notFoundBarcode(let placeholder):
                            NotFoundMealPlaceholderView {
                                viewModel.remove(placeholder: placeholder)
                            }
                        }
                    }
                }
                Spacer(minLength: .bottomSpacing)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: viewModel.selectedMealId) { id in
                scrollTo(id, reader: reader, anchor: .center)
            }
            .onReceive(viewModel.scrollToTopPublisher) { _ in
                scrollTo(topSpacerId, reader: reader)
            }
            .animation(.bouncy, value: viewModel.logItems)
        }
    }

    private func scrollTo<ID: Hashable>(_ id: ID, reader: ScrollViewProxy, anchor: UnitPoint = .center) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.linear) {
                reader.scrollTo(id, anchor: anchor)
            }
        }
    }
}

private extension CGFloat {
    static let topSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 183
    static let spacing: CGFloat = 8
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
        )
    )
}
