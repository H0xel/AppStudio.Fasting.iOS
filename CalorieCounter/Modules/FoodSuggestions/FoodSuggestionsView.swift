//
//  FoodSuggestionsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 01.05.2024.
//

import SwiftUI
import Combine
import AppStudioStyles
import AppStudioUI

struct FoodSuggestionsView: View {

    @Binding var scrollOffset: CGFloat
    let isFocused: Bool
    let inputHeight: CGFloat
    let canShowFavorites: Bool
    @StateObject var viewModel: FoodSuggestionsViewModel

    @State private var viewId = UUID()
    @State private var isDraging = false

    var body: some View {
        currentView
            .animation(.linear(duration: 0.2), value: viewModel.suggestedMeals)
            .animation(.linear(duration: 0.2), value: viewModel.isSuggestionsPresented)
            .onChange(of: isFocused) { isFocused in
                if isFocused {
                    viewModel.isSuggestionsPresented = true
                }
            }
            .onChange(of: viewModel.isSuggestionsPresented) { isSuggestionsPresented in
                viewModel.toggleSuggestions(isPresented: isSuggestionsPresented)
            }
            .onChange(of: viewModel.suggestedMeals) { _ in
                viewId = .init()
            }
            .onChange(of: viewModel.searchRequest) { _ in
                viewId = .init()
            }
            .onChange(of: viewModel.selectedItemIds) { _ in
                viewId = .init()
            }
            .onChange(of: canShowFavorites) { canShowFavorites in
                viewModel.toggleFavorites(canShowFavorites: canShowFavorites)
            }
    }

    @ViewBuilder
    var currentView: some View {
        if !viewModel.suggestedMeals.isEmpty {
            cardView
        } else {
            emptyView
        }
    }

    var emptyView: some View {
        CardView {
            if viewModel.searchRequest.isEmpty {
                FoodSuggestionsEmptyView()
                    .offset(y: -inputHeight / 2)
                    .aligned(.centerVerticaly)
                    .aligned(.centerHorizontaly)
            } else {
                FoodSearchEmptyView()
                    .offset(y: -inputHeight / 2)
                    .aligned(.centerVerticaly)
                    .aligned(.centerHorizontaly)
                    .opacity(isDraging || viewModel.isSuggestionsPresented ? 1 : 0)
            }
        }
        .modifier(DragableModifier(isCollapsed: !viewModel.isSuggestionsPresented,
                                   minTopPadding: .minTopPadding,
                                   bottomPadding: inputHeight,
                                   onChangeCollapsed: toggleCollapsed,
                                   onDraging: onDraging))
    }

    var cardView: some View {
        DragableCardView(scrollViewOffset: $scrollOffset,
                         isCollapsed: !viewModel.isSuggestionsPresented,
                         viewId: viewId,
                         minTopPadding: .minTopPadding,
                         bottomPadding: inputHeight,
                         onChangeCollapsed: toggleCollapsed) {
            LazyVStack(spacing: .zero) {
                ForEach(viewModel.suggestedMeals, id: \.self) { suggestedMeal in
                    SuggestedMealItemView(meal: suggestedMeal,
                                          searchRequest: viewModel.searchRequest,
                                          isSelected: viewModel.isSelected(meal: suggestedMeal.mealItem),
                                          onTap: viewModel.toggleSelection)
                    .padding(.vertical, .itemVerticalPadding)
                }
            }
            .padding(.horizontal, .horizontalPadding)
            Spacer(minLength: inputHeight)
        }
    }

    private func toggleCollapsed(_ isCollapsed: Bool) {
        viewModel.isSuggestionsPresented = !isCollapsed
    }

    private func onDraging(_ isDraging: Bool) {
        self.isDraging = isDraging
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 10
    static let horizontalPadding: CGFloat = 16
    static let bottomSpacing: CGFloat = 16
    static let itemVerticalPadding: CGFloat = 10
    static let minTopPadding: CGFloat = 44
}

#Preview {
    FoodSuggestionsView(
        scrollOffset: .constant(0),
        isFocused: false,
        inputHeight: 121,
        canShowFavorites: true,
        viewModel: .init(
            input: .init(mealPublisher: Just([]).eraseToAnyPublisher(),
                         mealType: .breakfast,
                         mealRequestPublisher: Just("").eraseToAnyPublisher(),
                         isPresented: true,
                         collapsePublisher: Just(()).eraseToAnyPublisher(),
                         searchRequest: ""),
            output: { _ in }
        )
    )
}

enum FoodSuggestionsSection {
    case favorites
    case history
}

