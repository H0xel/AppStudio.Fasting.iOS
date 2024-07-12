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
}

class FoodSuggestionsViewModel: BaseViewModel<FoodSuggestionsOutput> {

    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService
    @Published var suggestedMeals: [SuggestedMeal] = []
    @Published var isSuggestionsPresented: Bool
    @Published var searchRequest = ""
    private let mealType: MealType
    @Published private var canShowFavorites = true
    @Published var selectedItemIds: Set<String> = []
    private var canToggle = true

    init(input: FoodSuggestionsInput,
         output: @escaping ViewOutput<FoodSuggestionsOutput>) {
        mealType = input.mealType
        isSuggestionsPresented = input.isPresented
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

    func toggleFavorites(canShowFavorites: Bool) {
        self.canShowFavorites = canShowFavorites
        loadMeals(searchRequest: searchRequest)
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
//        let itemsWithIngredients = mealItemsWithIngredients(mealItems)
//        return itemsWithIngredients
        return mealItems
            .filter { !favoriteMealSet.contains($0) }
            .map { SuggestedMeal(icon: .init(.logItemsSuggest), mealItem: $0) }
    }

    private func mealItemsWithIngredients(_ mealItems: [MealItem]) -> [MealItem] {
        var ingredients: Set<String> = []
        var result: [MealItem] = []
        for item in mealItems {
            result.append(item)
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
}
//
//
//import Foundation
//import AppStudioUI
//import Dependencies
//import Combine
//
//private let isFoodSuggestionsPresentedKey = "isFoodSuggestionsPresentedKey"
//
//enum FoodSuggestionsOutput {
//    case add(MealItem)
//    case remove(MealItem)
//    case togglePresented(isPresented: Bool)
//}
//
//struct FoodSuggestionsInput {
//    let mealPublisher: AnyPublisher<[MealItem], Never>
//    let mealType: MealType
//    let mealRequestPublisher: AnyPublisher<String, Never>
//    let isPresented: Bool
//    let collapsePublisher: AnyPublisher<Void, Never>
//    let searchRequest: String
//}
//
//class FoodSuggestionsViewModel: BaseViewModel<FoodSuggestionsOutput> {
//
//    @Dependency(\.mealItemService) private var mealItemService
//    @Dependency(\.mealUsageService) private var mealUsageService
//
//    @Published var isSuggestionsPresented: Bool
//    @Published var searchRequest = ""
//    @Published var selectedItemIds: Set<String> = []
//    @Published private var canShowFavorites = true
//    @Published private var suggestedMeals: [SuggestedMeal] = []
//    private var canToggle = true
//    private let mealType: MealType
//
//    init(input: FoodSuggestionsInput,
//         output: @escaping ViewOutput<FoodSuggestionsOutput>) {
//        mealType = input.mealType
//        isSuggestionsPresented = input.isPresented
//        super.init(output: output)
//        loadMealItems()
//        observeRequest(publisher: input.mealRequestPublisher)
//        observeCollapsePublisher(input.collapsePublisher)
//        observeMeals(publisher: input.mealPublisher)
//    }
//
//    var suggestions: [SuggestedMeal] {
//        if searchRequest.isEmpty {
//            return suggestedMeals
//        }
//        let request = searchRequest.lowercased()
//        return suggestedMeals
//            .filter { $0.mealItem.mealName.lowercased().contains(request) }
//            .map { .init(icon: .init(.logItemsSuggest), mealItem: $0.mealItem) }
//            .sorted(by: {
//                let firstName = $0.mealItem.name
//                let firstIndex = firstName.range(
//                    of: request,
//                    options: .caseInsensitive
//                )?.lowerBound ?? firstName.startIndex
//                let secondName = $1.mealItem.name
//                let secondIndex = secondName.range(
//                    of: request,
//                    options: .caseInsensitive
//                )?.lowerBound ?? secondName.startIndex
//                return firstIndex < secondIndex
//            })
//
//    }
//
//    func isSelected(meal: MealItem) -> Bool {
//        selectedItemIds.contains(meal.id)
//    }
//
//    func toggleSelection(_ mealItem: MealItem) {
//        if !selectedItemIds.contains(mealItem.id) {
//            selectedItemIds.insert(mealItem.id)
//            output(.add(mealItem))
//        } else {
//            selectedItemIds.remove(mealItem.id)
//            output(.remove(mealItem))
//        }
//    }
//
//    func toggleSuggestions(isPresented: Bool) {
//        guard canToggle else {
//            canToggle = true
//            return
//        }
//        if isPresented {
//            loadMealItems()
//        }
//        output(.togglePresented(isPresented: isPresented))
//    }
//
//    func toggleFavorites(canShowFavorites: Bool) {
//        self.canShowFavorites = canShowFavorites
//        loadMealItems()
//    }
//
//    private func observeMeals(publisher: AnyPublisher<[MealItem], Never>) {
//        publisher
//            .receive(on: DispatchQueue.main)
//            .sink(with: self) { this, items in
//                for item in items {
//                    this.selectedItemIds.insert(item.id)
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    private func observeRequest(publisher: AnyPublisher<String, Never>) {
//        publisher
//            .removeDuplicates()
//            .handleEvents(receiveOutput: { [weak self] request in
//                if !request.isEmpty, request != "\n" {
//                    self?.isSuggestionsPresented = true
//                }
//            })
//            .debounce(for: 0.5, scheduler: DispatchQueue.main)
//            .receive(on: DispatchQueue.main)
//            .sink(with: self) { this, request in
//                this.searchRequest = request
//            }
//            .store(in: &cancellables)
//    }
//
//    private func loadMealItems() {
//        Task { [weak self] in
//            guard let self else { return }
//
//            var favoriteMeals: [SuggestedMeal] = []
//            if canShowFavorites {
//                favoriteMeals = try await favoriteSuggestions()
//            }
//
//            let allMeals = try await allSuggestions(except: favoriteMeals)
//            await MainActor.run { [favoriteMeals] in
//                self.suggestedMeals = favoriteMeals + allMeals
//            }
//        }
//    }
//
//    private func favoriteSuggestions() async throws -> [SuggestedMeal] {
//        let mealType = mealType
//        let favoriteMealItems = try await mealUsageService.favoriteMealItems(count: 3, mealType: mealType)
//        return favoriteMealItems.map { SuggestedMeal(icon: mealType.image, mealItem: $0) }
//    }
//
//    private func allSuggestions(except favoriteMeal: [SuggestedMeal]) async throws -> [SuggestedMeal] {
//        let favoriteMealSet = Set(favoriteMeal.map { $0.mealItem })
//        let mealItems = try await mealItemService.sortedMealItems()
//        let itemsWithIngredients = mealItemsWithIngredients(mealItems)
//        return itemsWithIngredients
//            .filter { !favoriteMealSet.contains($0) }
//            .map { SuggestedMeal(icon: .init(.logItemsSuggest), mealItem: $0) }
//    }
//
//    private func mealItemsWithIngredients(_ mealItems: [MealItem]) -> [MealItem] {
//        var ingredients: Set<String> = []
//        var result: [MealItem] = []
//        for item in mealItems {
//            result.append(item)
//            if item.ingredients.count == 1 {
//                continue
//            }
//            for ingredient in item.ingredients where !ingredients.contains(ingredient.mealName.lowercased().trim) {
//                result.append(ingredient)
//                ingredients.insert(ingredient.mealName.lowercased().trim)
//            }
//        }
//        return result
//    }
//
//    private func observeCollapsePublisher(_ publisher: AnyPublisher<Void, Never>) {
//        publisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.canToggle = false
//                self?.isSuggestionsPresented = false
//            }
//            .store(in: &cancellables)
//    }
//}
