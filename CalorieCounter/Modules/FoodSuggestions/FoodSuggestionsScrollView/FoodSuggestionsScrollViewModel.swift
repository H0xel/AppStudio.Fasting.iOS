//
//  FoodSuggestionsScrollViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.07.2024.
//

import UIKit
import Combine

enum FoodSuggestionsViewControllerOutput {
    case scrollViewDidScroll(UIScrollView)
    case scrollViewWillBeginDragging
    case scrollViewEndScrolling
    case add(MealItem)
    case remove(MealItem)
}

class FoodSuggestionsScrollViewModel {

    @Published var searchRequest = ""
    @Published private var mealsSubject: [SuggestedMeal] = []
    private var selectedItemIds: Set<String> = []
    private var output: ((FoodSuggestionsViewControllerOutput) -> Void)?
    private let reloadSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(mealsPublisher: AnyPublisher<[SuggestedMeal], Never>,
         initialMealsPublisher: AnyPublisher<[MealItem], Never>,
         searchRequestPublisher: AnyPublisher<String, Never>,
         output: @escaping (FoodSuggestionsViewControllerOutput) -> Void) {
        self.output = output
        observeSuggestedMeals(mealsPublisher: mealsPublisher)
        obserSelectedItemsIds(initialMealsPublisher: initialMealsPublisher)
        observeSearchRequest(searchRequestPublisher: searchRequestPublisher)
    }

    var mealsPublisher: AnyPublisher<[SuggestedMeal], Never> {
        $mealsSubject.eraseToAnyPublisher()
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

    private func observeSuggestedMeals(mealsPublisher: AnyPublisher<[SuggestedMeal], Never>) {
        mealsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$mealsSubject)
    }

    private func observeSearchRequest(searchRequestPublisher: AnyPublisher<String, Never>) {
        searchRequestPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchRequest)
    }
}
