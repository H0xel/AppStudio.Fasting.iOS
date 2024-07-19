//
//  FoodSuggestionsViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 01.05.2024.
//

import Foundation
import AppStudioUI
import Dependencies
import Combine

private let isFoodSuggestionsPresentedKey = "isFoodSuggestionsPresentedKey"

class FoodSuggestionsViewModel: BaseViewModel<FoodSuggestionsOutput> {

    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService
    @Published private var suggestedMeals: [SuggestedMeal] = []
    @Published var isSuggestionsPresented: Bool
    @Published var searchRequest = ""
    private let mealType: MealType
    @Published private var canShowFavorites = true
    private var canToggle = true
    let initialMealPublisher: AnyPublisher<[MealItem], Never>
    private let showOnlyIngredients: Bool

    init(input: FoodSuggestionsInput,
         output: @escaping ViewOutput<FoodSuggestionsOutput>) {
        mealType = input.mealType
        isSuggestionsPresented = input.isPresented
        initialMealPublisher = input.mealPublisher
        showOnlyIngredients = input.showOnlyIngredients
        super.init(output: output)
        loadMealItems()
        observeRequest(publisher: input.mealRequestPublisher)
        observeCollapsePublisher(input.collapsePublisher)
    }

    var mealsPublisher: AnyPublisher<[SuggestedMeal], Never> {
         allMealsPublisher
            .merge(with: filteredMeals)
            .eraseToAnyPublisher()
    }

    func toggleSuggestions(isPresented: Bool) {
        guard canToggle else {
            canToggle = true
            return
        }
        if isPresented {
            loadMealItems()
        }
        output(.togglePresented(isPresented: isPresented))
    }

    func toggleFavorites(canShowFavorites: Bool) {
        self.canShowFavorites = canShowFavorites
        loadMealItems()
    }

    func hadle(foodSuggestionsScrollViewOutput output: FoodSuggestionsScrollViewOutput) {
        switch output {
        case .add(let mealItem):
            self.output(.add(mealItem))
        case .remove(let mealItem):
            self.output(.remove(mealItem))
        }
    }

    private func observeRequest(publisher: AnyPublisher<String, Never>) {
        publisher
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] request in
                if !request.isEmpty, request != "\n" {
                    self?.isSuggestionsPresented = true
                }
            })
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchRequest)
    }

    private func loadMealItems() {
        Task { [weak self] in
            guard let self else { return }

            var favoriteMeals: [SuggestedMeal] = []
            if canShowFavorites {
                favoriteMeals = try await favoriteSuggestions()
            }

            let allMeals = try await allSuggestions(except: favoriteMeals)
            await MainActor.run { [favoriteMeals] in
                self.suggestedMeals = favoriteMeals + allMeals
            }
        }
    }

    private func favoriteSuggestions() async throws -> [SuggestedMeal] {
        let mealType = mealType
        let favoriteMealItems = try await mealUsageService.favoriteMealItems(count: 3, mealType: mealType)
        return favoriteMealItems.map { SuggestedMeal(icon: mealType.image, mealItem: $0) }
    }

    private func allSuggestions(except favoriteMeal: [SuggestedMeal]) async throws -> [SuggestedMeal] {
        let favoriteMealSet = Set(favoriteMeal.map { $0.mealItem })
        let mealItems = try await mealItemService.sortedMealItems()
        let itemsWithIngredients = mealItemsWithIngredients(mealItems)
        return itemsWithIngredients
            .filter { !favoriteMealSet.contains($0) }
            .map { SuggestedMeal(icon: .init(.logItemsSuggest), mealItem: $0) }
    }

    private func mealItemsWithIngredients(_ mealItems: [MealItem]) -> [MealItem] {
        var ingredients: Set<String> = []
        var result: [MealItem] = []
        for item in mealItems {
            if !showOnlyIngredients {
                result.append(item)
            }
            if item.ingredients.count == 1 {
                continue
            }
            for ingredient in item.ingredients where !ingredients.contains(ingredient.mealName.lowercased().trim) {
                result.append(ingredient)
                ingredients.insert(ingredient.mealName.lowercased().trim)
            }
        }
        return result
    }

    private func observeCollapsePublisher(_ publisher: AnyPublisher<Void, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.canToggle = false
                self?.isSuggestionsPresented = false
            }
            .store(in: &cancellables)
    }

    private var allMealsPublisher: AnyPublisher<[SuggestedMeal], Never> {
        $searchRequest
            .filter { $0.isEmpty }
            .map(with: self) { this, _ in
                this.suggestedMeals
            }
            .eraseToAnyPublisher()
    }

    private var filteredMeals: AnyPublisher<[SuggestedMeal], Never> {
        $searchRequest
            .filter { !$0.isEmpty }
            .map(with: self) { this, request in
                this.suggestedMeals
                    .filter { $0.mealItem.mealName.trim.lowercased().contains(request.trim.lowercased()) }
                    .sorted(by: {
                        let firstName = $0.mealItem.name
                        let firstIndex = firstName.firstIndex(of: request) ?? firstName.startIndex
                        let secondName = $1.mealItem.name
                        let secondIndex = secondName.firstIndex(of: request) ?? secondName.startIndex
                        return firstIndex < secondIndex
                    })
            }
    }
}
