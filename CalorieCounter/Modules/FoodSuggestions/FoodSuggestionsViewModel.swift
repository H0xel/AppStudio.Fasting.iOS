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

enum FoodSuggestionsOutput {
    case add(MealItem)
    case remove(MealItem)
    case togglePresented(isPresented: Bool)
}

struct FoodSuggestionsInput {
    let mealPublisher: AnyPublisher<[MealItem], Never>
    let mealType: MealType
    let mealRequestPublisher: AnyPublisher<String, Never>
    let isPresented: Bool
    let collapsePublisher: AnyPublisher<Void, Never>
    let searchRequest: String
    let canShowFavorites: Bool
}

class FoodSuggestionsViewModel: BaseViewModel<FoodSuggestionsOutput> {

    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService
    @Published var suggestedMeals: [SuggestedMeal] = []
    @Published var isSuggestionsPresented: Bool
    @Published var searchRequest = ""
    private let mealType: MealType
    private let canShowFavorites: Bool
    @Published var selectedItemIds: Set<String> = []
    private var canToggle = true

    init(input: FoodSuggestionsInput,
         output: @escaping ViewOutput<FoodSuggestionsOutput>) {
        mealType = input.mealType
        isSuggestionsPresented = input.isPresented
        canShowFavorites = input.canShowFavorites
        super.init(output: output)
        loadMeals(searchRequest: input.searchRequest)
        observeRequest(publisher: input.mealRequestPublisher)
        observeCollapsePublisher(input.collapsePublisher)
        observeMeals(publisher: input.mealPublisher)
    }

    func isSelected(meal: MealItem) -> Bool {
        selectedItemIds.contains(meal.id)
    }

    func toggleSelection(_ mealItem: MealItem) {
        if !selectedItemIds.contains(mealItem.id) {
            selectedItemIds.insert(mealItem.id)
            output(.add(mealItem))
        } else {
            selectedItemIds.remove(mealItem.id)
            output(.remove(mealItem))
        }
    }

    func toggleSuggestions(isPresented: Bool) {
        guard canToggle else {
            canToggle = true
            return
        }
        if isPresented {
            loadMeals(searchRequest: searchRequest)
        }
        output(.togglePresented(isPresented: isPresented))
    }

    private func observeMeals(publisher: AnyPublisher<[MealItem], Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, items in
                for item in items {
                    this.selectedItemIds.insert(item.id)
                }
            }
            .store(in: &cancellables)
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
            .sink(with: self) { this, request in
                this.loadMeals(searchRequest: request)
            }
            .store(in: &cancellables)
    }

    private func loadMeals(searchRequest: String) {
        if searchRequest.isEmpty {
            self.searchRequest = ""
            loadMealItems()
        } else {
            self.searchRequest = searchRequest
            searchMealItems(request: searchRequest)
        }
    }

    private func searchMealItems(request: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let items = try await self.mealItemService.mealItemBy(request: request)
            suggestedMeals = items.map {
                .init(icon: .init(.logItemsSuggest), mealItem: $0)
            }
            .sorted(by: {
                let firstName = $0.mealItem.name
                let firstIndex = firstName.range(
                    of: request,
                    options: .caseInsensitive
                )?.lowerBound ?? firstName.startIndex
                let secondName = $1.mealItem.name
                let secondIndex = secondName.range(
                    of: request,
                    options: .caseInsensitive
                )?.lowerBound ?? secondName.startIndex
                return firstIndex < secondIndex
            })
        }
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
        return mealItems
            .filter { !favoriteMealSet.contains($0) }
            .map { SuggestedMeal(icon: .init(.logItemsSuggest), mealItem: $0) }
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
}
