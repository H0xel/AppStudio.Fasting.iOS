//
//  FoodSuggestionsScrollView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.07.2024.
//

import SwiftUI
import Combine

enum FoodSuggestionsScrollViewOutput {
    case add(MealItem)
    case remove(MealItem)
}

struct FoodSuggestionsScrollView: UIViewControllerRepresentable {

    let mealsPublisher: AnyPublisher<[SuggestedMeal], Never>
    let initialMealPublisher: AnyPublisher<[MealItem], Never>
    let searchRequestPublisher: AnyPublisher<String, Never>
    @Binding var isDragging: Bool
    @Binding var dragOffset: CGFloat
    @Binding var scrollOffset: CGFloat
    @Binding var contentOffset: CGFloat
    let output: (FoodSuggestionsScrollViewOutput) -> Void

    func makeUIViewController(context: Context) -> FoodSuggestionsViewController {
        let viewModel = FoodSuggestionsScrollViewModel(
            mealsPublisher: mealsPublisher,
            initialMealsPublisher: initialMealPublisher,
            searchRequestPublisher: searchRequestPublisher) { output in
                handle(output: output)
            }
        return FoodSuggestionsViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: FoodSuggestionsViewController, context: Context) {}

    func handle(output: FoodSuggestionsViewControllerOutput) {
        switch output {
        case .scrollViewDidScroll(let scrollView):
            scrollViewDidScroll(scrollView)
        case .scrollViewWillBeginDragging:
            isDragging = true
        case .scrollViewEndScrolling:
            isDragging = false
        case .add(let mealItem):
            self.output(.add(mealItem))
        case .remove(let mealItem):
            self.output(.remove(mealItem))
        }
    }

    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        let contentHeight = scrollView.contentSize.height
        let scrollViewSize = scrollView.frame.size.height
        if contentHeight > scrollViewSize, offset > contentHeight - scrollViewSize {
            let xPosition = scrollView.contentOffset.x
            let scrollPosition = CGPoint(x: xPosition, y: contentHeight - scrollViewSize)
            scrollOffset = scrollPosition.y
            dragOffset = -scrollPosition.y
            scrollView.setContentOffset(scrollPosition, animated: false)
            return
        }
        scrollOffset = offset
        guard scrollView.isDragging, !scrollView.isDecelerating else {
            return
        }
        if offset > 0, contentOffset > 0 {
            scrollView.setContentOffset(.init(x: 0, y: 0), animated: false)
        }
        dragOffset = -offset
    }
}
