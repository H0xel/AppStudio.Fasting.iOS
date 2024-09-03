//
//  FoodSuggestionsScrollViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.07.2024.
//

import UIKit
import Combine
import Dependencies

enum FoodSuggestionsViewControllerOutput {
    case scrollViewDidScroll(UIScrollView)
    case scrollViewWillBeginDragging
    case scrollViewEndScrolling
    case add(MealItem)
    case remove(MealItem)
    case present(MealItem)
}

class FoodSuggestionsScrollViewModel {

    let mealPublisher: AnyPublisher<[SuggestedMeal], Never>
    let searchRequestPublisher: AnyPublisher<String, Never>
    private var selectedItemIds: Set<String> = []
    private var output: ((FoodSuggestionsViewControllerOutput) -> Void)?
    private let reloadSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    @Dependency(\.foodSearchService) private var foodSearchService

    init(mealsPublisher: AnyPublisher<[SuggestedMeal], Never>,
         initialMealsPublisher: AnyPublisher<[MealItem], Never>,
         searchRequestPublisher: AnyPublisher<String, Never>,
         output: @escaping (FoodSuggestionsViewControllerOutput) -> Void) {
        self.output = output
        mealPublisher = mealsPublisher
        self.searchRequestPublisher = searchRequestPublisher
        obserSelectedItemsIds(initialMealsPublisher: initialMealsPublisher)
    }

    var reloadPublisher: AnyPublisher<Void, Never> {
        reloadSubject
            .eraseToAnyPublisher()
    }

    func isSelected(meal: MealItem) -> Bool {
        selectedItemIds.contains(meal.id)
    }

    func toggleSelection(_ mealItem: MealItem) {
        if !selectedItemIds.contains(mealItem.id) {
            output?(.add(mealItem))
        } else {
            output?(.remove(mealItem))
        }
    }

    func select(_ mealItem: MealItem) {
        let foodSearchService = foodSearchService
        switch mealItem.type {
        case .needToUpdateBrand:
            Task {
                let brandedMealItem = try await foodSearchService.searchBranded(brandFoodId: mealItem.brandFoodId ?? "") ?? mealItem
                DispatchQueue.main.async { [weak self] in
                    self?.output?(.present(brandedMealItem))
                }
            }
        default:
            output?(.present(mealItem))
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output?(.scrollViewDidScroll(scrollView))
    }

    func scrollViewWillBeginDragging() {
        output?(.scrollViewWillBeginDragging)
    }

    func scrollViewEndScrolling() {
        output?(.scrollViewEndScrolling)
    }

    private func obserSelectedItemsIds(initialMealsPublisher: AnyPublisher<[MealItem], Never>) {
        initialMealsPublisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, items in
                this.selectedItemIds = []
                for item in items {
                    this.selectedItemIds.insert(item.id)
                }
                this.reloadSubject.send()
            }
            .store(in: &cancellables)
    }
}
