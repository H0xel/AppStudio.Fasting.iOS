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
    var minTopPadding: CGFloat = .minTopPadding
    @StateObject var viewModel: FoodSuggestionsViewModel

    @State private var isDraging = false
    @State private var dragScrollViewOffset: CGFloat = 0
    @State private var contentOffset: CGFloat = .zero
    @State private var isDraggingScrollView = false
    @State private var isMealsEmpty = true

    var body: some View {
        currentView
            .onChange(of: isFocused) { isFocused in
                if isFocused {
                    viewModel.isSuggestionsPresented = true
                }
            }
            .onChange(of: viewModel.isSuggestionsPresented) { isSuggestionsPresented in
                viewModel.toggleSuggestions(isPresented: isSuggestionsPresented)
            }
            .onChange(of: canShowFavorites) { canShowFavorites in
                viewModel.toggleFavorites(canShowFavorites: canShowFavorites)
            }
            .onAppear {
                viewModel.toggleFavorites(canShowFavorites: canShowFavorites)
            }
            .onReceive(viewModel.mealsPublisher.map { $0.isEmpty }) { isEmpty in
                isMealsEmpty = isEmpty
            }
    }

    @ViewBuilder
    var currentView: some View {
        if isMealsEmpty {
            emptyView
        } else {
            cardView
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
                                   minTopPadding: minTopPadding,
                                   bottomPadding: inputHeight,
                                   onChangeCollapsed: toggleCollapsed,
                                   onDraging: onDraging))
    }

    var cardView: some View {
        CardView {
            FoodSuggestionsScrollView(
                mealsPublisher: viewModel.mealsPublisher,
                initialMealPublisher: viewModel.initialMealPublisher,
                searchRequestPublisher: viewModel.$searchRequest.eraseToAnyPublisher(),
                isDragging: $isDraggingScrollView,
                dragOffset: $dragScrollViewOffset,
                scrollOffset: $scrollOffset,
                contentOffset: $contentOffset, 
                output: viewModel.hadle
            )
        }
        .modifier(DragableModifier(isCollapsed: !viewModel.isSuggestionsPresented,
                                   minTopPadding: minTopPadding + contentOffset,
                                   bottomPadding: inputHeight,
                                   onChangeCollapsed: toggleCollapsed))
        .onChange(of: isDraggingScrollView) { isDragging in
            if !isDragging, contentOffset > 0 {
                toggleCollapsed(contentOffset > 50)
            }
            if contentOffset <= 50 {
                withAnimation(.bouncy) {
                    dragScrollViewOffset = 0
                    contentOffset = 0
                }
            }
        }
        .onChange(of: dragScrollViewOffset) { newValue in
            guard isDraggingScrollView else {
                contentOffset = 0
                dragScrollViewOffset = 0
                return
            }
            contentOffset = max(0, contentOffset + newValue)
        }
        .onChange(of: viewModel.isSuggestionsPresented) { newValue in
            dragScrollViewOffset = 0
            contentOffset = 0
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
                         searchRequest: "",
                         showOnlyIngredients: false),
            output: { _ in }
        )
    )
}
