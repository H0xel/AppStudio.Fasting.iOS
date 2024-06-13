//
//  MealViewViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import Foundation
import AppStudioUI
import Dependencies
import Combine

class MealViewViewModel: BaseViewModel<MealViewOutput> {

    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.mealService) private var mealService
    @Dependency(\.mealUsageService) private var mealUsageService
    @Dependency(\.calorieCounterService) private var calorieCounterService
    @Dependency(\.foodSearchService) private var foodSearchService

    @Published var meal: Meal
    @Published var mealSelectedState: MealSelectedState = .notSelected
    @Published var ingredientPlaceholders: [MealPlaceholder] = []
    @Published var hasSubscription: Bool = false

    private let router: MealViewRouter

    init(meal: Meal,
         mealSelectionPublisher: AnyPublisher<String, Never>,
         hasSubscriptionPublisher: AnyPublisher<Bool, Never>,
         router: MealViewRouter,
         output: @escaping ViewOutput<MealViewOutput>) {
        self.meal = meal
        self.router = router
        super.init(output: output)
        hasSubscriptionPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasSubscription)
        observeMealSelectionPublisher(publisher: mealSelectionPublisher)
        observeMealSelectedState()
    }

    var isTapped: Bool {
        if case .delete = mealSelectedState {
            return true
        }
        return false
    }

    var isWeightTapped: Bool {
        if case .mealWeight = mealSelectedState {
            return true
        }
        return false
    }

    var mealItem: MealItem {
        meal.mealItem
    }

    var isHeaderHidden: Bool {
        isQuickAdd && mealItem.mealName.isEmpty
    }

    var nutritionProfile: NutritionProfile {
        mealItem.nutritionProfile
    }

    var isQuickAdd: Bool {
        mealItem.creationType == .quickAdd
    }

    var ingredients: [Ingredient] {
        mealItem.ingredients
    }

    var votingViewModel: MealVotingViewModel {
        .init(meal: meal) { [weak self] meal in
            self?.meal = meal
            self?.output(.mealUpdated(meal: meal))
        }
    }

    var canShowWeightIcon: Bool {
        ingredients.count == 1 && !meal.isQuickAdded
    }

    func ingredientViewModel(ingredient: Ingredient) -> IngredientViewModel {
        .init(input: .init(
            ingredient: ingredient,
            router: .init(navigator: router.navigator),
            statePublisher: $mealSelectedState
                .removeDuplicates()
                .map { $0.ingredient }
                .eraseToAnyPublisher()
        )) { [weak self] output in
            self?.handle(ingredientOutput: output)
        }
    }

    func weightTapped() {
        trackerService.track(.tapChangeWeight(context: .meal))
        if case .mealWeight = mealSelectedState {
            clearSelection()
            return
        }
        mealSelectedState = .mealWeight
        router.presentChangeWeightBanner(title: mealItem.mealName,
                                         initialWeight: mealItem.weight) { [weak self] weight in
            self?.changeMealWeight(to: weight)
        } onCancel: { [weak self] in
            self?.clearSelection()
        }
        output(.banner(isPresented: true))
    }

    func addIngredients() {
        mealSelectedState = .notSelected
        output(.banner(isPresented: true))
        router.presentAddIngredientBanner(meal: meal) { [weak self] ingredientName in
            guard let self else { return }
            clearSelection()
            Task { [weak self] in
               try await self?.requestIngredients(with: ingredientName)
            }
        } onBarcodeScan: { [weak self] isAccesGranted in
            self?.clearSelection()
            self?.barcodeScan(accessGranted: isAccesGranted)
        } onDismissFocus: { [weak self] in
            self?.clearSelection()
        }
    }

    func clearSelection() {
        mealSelectedState = .notSelected
        output(.banner(isPresented: false))
        router.dismissBanner()
    }

    func tapMeal() {
        trackerService.track(.elementChosen(context: .meal))
        if case .delete = mealSelectedState {
            clearSelection()
            return
        }
        mealSelectedState = .delete
        presentMealDeleteBanner(meal)
        output(.banner(isPresented: true))
    }

    func closeIngredientPlaceholder(with id: String) {
        Task {
            await removeIngredientPlaceholder(placeholderId: id)
        }
    }

    private func handle(ingredientOutput: IngredientOutput) {
        switch ingredientOutput {
        case .ingredientTapped(let ingredient):
            mealSelectedState = .ingredient(ingredient)
            output(.banner(isPresented: true))
        case .weightTapped(let ingredient):
            mealSelectedState = .ingredientWeight(ingredient)
            output(.banner(isPresented: true))
        case .deleted(let ingredient):
            let newIngredients = meal.mealItem.ingredients.filter { $0 != ingredient }
            updateIngredients(newIngredients: newIngredients)
        case .updated(newIngredient: let newIngredient, oldIngredient: let oldIngredient):
            guard let index = ingredients.firstIndex(of: oldIngredient) else { return }
            var newIngredients = ingredients
            newIngredients[index] = newIngredient
            updateIngredients(newIngredients: newIngredients)
        case .notSelected:
            clearSelection()
        }
    }

    private func updateIngredients(newIngredients: [Ingredient]) {
        let newMeal = meal.copyWith(ingredients: newIngredients)
        updateMeal(newMeal)
        output(.mealUpdated(meal: newMeal))
    }

    private func changeMealWeight(to newWeight: Double) {
        guard Int(newWeight) != Int(mealItem.weight) else {
            clearSelection()
            return
        }
        let difference = mealItem.weight == 0 ? 0 : newWeight / mealItem.weight

        let newIngredients = ingredients.map {
            Ingredient(name: $0.name,
                       brandTitle: $0.brandTitle,
                       weight: difference != 0 ? $0.weight * difference : newWeight / Double(ingredients.count),
                       normalizedProfile: $0.normalizedProfile)
        }
        let changedMeal = meal.copyWith(ingredients: newIngredients)
        updateMeal(changedMeal)
        output(.mealUpdated(meal: changedMeal))
        clearSelection()
        trackerService.track(.weightChanged(currentWeight: newWeight,
                                            previousWeight: meal.mealItem.weight,
                                            context: .meal))
    }

    private func updateMeal(_ meal: Meal) {
        Task { [weak self] in
            guard let self else { return }
            let meal = try await self.mealService.save(meal: meal)
            await MainActor.run { [weak self] in
                self?.meal = meal
            }
        }
    }

    private func deleteMeal(_ meal: Meal) {
        Task { [weak self] in
            guard let self else { return }
            try await self.mealService.delete(byId: meal.id)
            try await mealUsageService.decrementUsage(meal.mealItem, mealType: meal.type)
        }
    }

    private func observeMealSelectionPublisher(publisher: AnyPublisher<String, Never>) {
        publisher
            .filter { [weak self] id in id != self?.meal.id  }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.mealSelectedState = .notSelected
            }
            .store(in: &cancellables)
    }

    private func observeMealSelectedState() {
        $mealSelectedState
            .filter { $0 != .notSelected }
            .sink(with: self) { this, _ in
                this.output(.selected(this.meal.id))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Request Ingredients
extension MealViewViewModel {

    private func requestIngredients(with text: String) async throws {
        let placeholder = await prepareIngredientPlaceholder(text: text)
        let ingredients = try await calorieCounterService.ingredients(request: text)
        await removePlaceholderAndUpdateIngredients(placeholderId: placeholder.id,
                                                    ingredients: ingredients + meal.mealItem.ingredients)
    }

    private func searchIngredient(barcode: String) async throws {
        let placeholder = await prepareIngredientPlaceholder(text: barcode)
        guard let ingredient = try await foodSearchService.searchIngredient(barcode: barcode) else {
            trackBarcodeScanned(isSucces: false, productName: nil)
            await setNotFoundForIngredientPlaceholder(placeholderId: placeholder.id)
            return
        }
        await removePlaceholderAndUpdateIngredients(placeholderId: placeholder.id,
                                                    ingredients: [ingredient] + meal.mealItem.ingredients)
    }

    @MainActor
    private func prepareIngredientPlaceholder(text: String) -> MealPlaceholder {
        router.dismissBanner()
        let placeholder = MealPlaceholder(mealText: text)
        ingredientPlaceholders.append(placeholder)
        trackerService.track(.entrySent)
        return placeholder
    }

    @MainActor
    private func removePlaceholderAndUpdateIngredients(placeholderId: String, ingredients: [Ingredient]) {
        removeIngredientPlaceholder(placeholderId: placeholderId)
        let meal = meal.copyWith(ingredients: ingredients)
        updateMeal(meal)
        output(.mealUpdated(meal: meal))
    }

    @MainActor
    private func setNotFoundForIngredientPlaceholder(placeholderId: String) {
        guard let index = ingredientPlaceholders.firstIndex(where: { $0.id == placeholderId }) else {
            return
        }
        ingredientPlaceholders[index].notFound = true
    }

    @MainActor
    private func removeIngredientPlaceholder(placeholderId: String) {
        ingredientPlaceholders.removeAll { $0.id == placeholderId }
    }
}

// MARK: - Barcode Scan
extension MealViewViewModel {
    func barcodeScan(accessGranted: Bool) {
        guard accessGranted else {
            router.presentCameraAccessAlert()
            return
        }
        guard hasSubscription else {
            presentPaywall { [weak self] in
                self?.output(.hasSubscription(true))
                self?.barcodeScan(accessGranted: accessGranted)
            }
            return
        }
        router.presentBarcodeScanner { [weak self] output in
            self?.onBarcode(output: output)
        }
    }

    private func onBarcode(output: BarcodeOutput) {
        router.dismiss()
        switch output {
        case .barcode(let barcode):
            Task {
                try await searchIngredient(barcode: barcode)
            }
        case .close:
            break
        }
    }

    private func presentPaywall(onSubscribe: (() -> Void)? = nil) {
        router.presentPaywall { [weak self] output in
            guard let self else { return }
            self.router.dismiss()
            switch output {
            case .close, .showDiscountPaywall:
                break
            case .subscribed:
                Task { @MainActor in
                    self.hasSubscription = true
                    onSubscribe?()
                }
            }
        }
    }
}

// MARK: - Routing
extension MealViewViewModel {
    private func presentMealDeleteBanner(_ meal: Meal) {
        router.presentDeleteBanner(editType: meal.isQuickAdded ? .quickAddMeal : .deleteMeal) { [weak self] in
            self?.clearSelection()
        } onDelete: { [weak self] in
            guard let self else { return }
            self.clearSelection()
            self.deleteMeal(meal)
            trackerService.track(.elementDeleted(context: .meal))
            output(.mealDeleted(meal: meal))
        } onEdit: { [weak self] in
            self?.clearSelection()
            self?.output(.editQuickAdd(meal))
        }
    }
}

// MARK: - Tracker
extension MealViewViewModel {
    private func trackBarcodeScanned(isSucces: Bool, productName: String?) {
        trackerService.track(.barcodeScanned(result: isSucces ? "success" : "fail",
                                             productName: productName))
    }
}
