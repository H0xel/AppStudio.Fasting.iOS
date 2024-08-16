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
import AppStudioNavigation
import SwiftUI

private let isFoodSuggestionsPresentedKey = "isFoodSuggestionsPresentedKey"

class FoodSuggestionsViewModel: BaseViewModel<FoodSuggestionsOutput> {

    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService
    @Dependency(\.foodSearchService) private var foodSearchService

    @Published private var suggestedMeals: [SuggestedMeal] = []
    @Published var isSuggestionsPresented: Bool
    @Published var searchRequest = ""
    @Published private var searchFoods: [SuggestedMeal] = []
    private var lastSearchRequest: String = ""
    private let mealType: MealType
    @Published var logType: LogType = .log
    private var canToggle = true
    let initialMealPublisher: AnyPublisher<[MealItem], Never>
    private let showOnlyIngredients: Bool
    private var mealItemObserver: MealItemObserver?
    private var mealItemCancellable: AnyCancellable?

    init(input: FoodSuggestionsInput,
         output: @escaping ViewOutput<FoodSuggestionsOutput>) {
        mealType = input.mealType
        isSuggestionsPresented = input.isPresented
        initialMealPublisher = input.mealPublisher
        showOnlyIngredients = input.showOnlyIngredients
        super.init(output: output)
        observeMealItems()
        observeRequest(publisher: input.mealRequestPublisher)
        observeCollapsePublisher(input.collapsePublisher)
        //--------------------------------
        // TODO: - раскомментировать для включения поиска еды из Nutrition API
        // observeSearchFoods()
        //________________________________
    }

    var mealsPublisher: AnyPublisher<[SuggestedMeal], Never> {
        Publishers.CombineLatest3($suggestedMeals, $searchRequest, $searchFoods)
            .map(with: self) { this, mealsAndRequest in
                let request = mealsAndRequest.1
                let favoriteAndHistoryMeals = mealsAndRequest.0
                let foodSearchMeals = mealsAndRequest.2
                if request.isEmpty {
                    return favoriteAndHistoryMeals
                }
                let meals = this.filteredMeals(meals: favoriteAndHistoryMeals, request: request) + foodSearchMeals
                let sorted = meals.sorted { $0.score(for: request) > $1.score(for: request) }
                return sorted
            }
            .eraseToAnyPublisher()
    }

    func observeSearchFoods() {
        Publishers.CombineLatest($searchRequest, $logType)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(with: self) { this, requestAndType in
                let query = requestAndType.0
                let type = requestAndType.1


                if type != .log || query.count < 3 {
                    this.searchFoods = []
                    this.lastSearchRequest = ""
                    return
                }

                let isDuplicate = this.lastSearchRequest == query
                this.lastSearchRequest = query

                if isDuplicate { return }

                Task {
                    do {
                        let foods = try await this.foodSearchService.searchText(query: query)
                        await MainActor.run {
                            this.searchFoods = foods.map { SuggestedMeal(type: .foodSearch, mealItem: $0) }
                        }
                    } catch {
                        assertionFailure("foodSearchService.searchText(query = \(query)")
                    }
                }
            }
            .store(in: &cancellables)
    }

    var foodSearchPublisher: AnyPublisher<[SuggestedMeal], Never> {
        let foodSearchService = foodSearchService

        let foodSearchPublisher: AnyPublisher<[SuggestedMeal], Never> = $searchRequest
            .filter { [weak self] in $0.count >= 3 && self?.logType == .log }
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates(by: { last, new in
                last != new
            })
            .receive(on: DispatchQueue.main)
            .flatMap(with: self) { this, query in
                return Future { promise in
                    Task {
                        do {
                            let foods = try await foodSearchService.searchText(query: query)
                            let result = foods.map { SuggestedMeal(type: .foodSearch, mealItem: $0) }
                            DispatchQueue.main.async {
                                promise(.success(result))
                            }
                        } catch {
                            assertionFailure("foodSearchService.searchText(query = \(query)")
                        }
                    }
                }
            }
            .eraseToAnyPublisher()

        let emptyFoodSearchPublisher: AnyPublisher<[SuggestedMeal], Never> = $searchRequest
            .filter { $0.count < 3 }
            .map { _ in [] }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        let foodSearchAllPublisher = Publishers.Merge(emptyFoodSearchPublisher, foodSearchPublisher)
            .eraseToAnyPublisher()

        return Publishers.CombineLatest(foodSearchAllPublisher, $logType)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }

    func toggleSuggestions(isPresented: Bool) {
        guard canToggle else {
            canToggle = true
            return
        }
        output(.togglePresented(isPresented: isPresented))
    }

    func changeLogType(to logType: LogType) {
        self.logType = logType
        isSuggestionsPresented = true
    }

    func hadle(foodSuggestionsScrollViewOutput output: FoodSuggestionsScrollViewOutput) {
        switch output {
        case .add(let mealItem):
            self.output(.add(mealItem))
        case .remove(let mealItem):
            self.output(.remove(mealItem))
        case .present(let mealItem):
            self.output(.present(mealItem))
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

    private func observeMealItems() {
        mealItemObserver = mealItemService.mealItemObserver()
        mealItemCancellable = mealItemObserver?.results.compactMap { $0 }
            .combineLatest($logType)
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, itemsWithLogType in
                this.assignSuggestedMeals(items: itemsWithLogType.0, logType: itemsWithLogType.1)
            }
    }

    private func assignSuggestedMeals(items: [MealItem], logType: LogType) {
        Task { [weak self] in
            guard let self else { return }
            let suggestedMeals = try await suggestedMeals(items: items, logType: logType)
            await MainActor.run { [weak self] in
                self?.suggestedMeals = suggestedMeals
            }
        }
    }

    private func suggestedMeals(items: [MealItem], logType: LogType) async throws -> [SuggestedMeal] {
        if showOnlyIngredients {
            return items
                .filter { $0.type == .ingredient }
                .map { SuggestedMeal(type: .history, mealItem: $0) }
        }
        switch logType {
        case .log:
            let notIngredients = items.filter { $0.type != .ingredient }.map { $0.id }
            let favoriteMeals = try await favoriteSuggestions(from: notIngredients)
            let favoriteMealSet = Set(favoriteMeals.map { $0.mealItem.id })
            let allItems: [SuggestedMeal] = items
                .filter { !favoriteMealSet.contains($0.id) }
                .map { SuggestedMeal(type: .history, mealItem: $0) }
            return favoriteMeals + allItems
        case .history, .quickAdd, .addRecipe, .newFood:
            return items
                .map { SuggestedMeal(type: .history, mealItem: $0) }
        case .food:
            return items
                .filter { $0.type == .product }
                .map { SuggestedMeal(type: .history, mealItem: $0) }
        }
    }

    private func favoriteSuggestions(from mealItemIds: [String]) async throws -> [SuggestedMeal] {
        let mealType = mealType
        let favoriteMealItems = try await mealUsageService.favoriteMealItems(from: mealItemIds,
                                                                             count: 3,
                                                                             mealType: mealType)
        return favoriteMealItems.map { SuggestedMeal(type: .favorite(mealType), mealItem: $0) }
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

    private func filteredMeals(meals: [SuggestedMeal], request: String) -> [SuggestedMeal] {
        meals
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
