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
    @Published var editingWeight: CustomKeyboardResult?
    private let tappedIngredientSubject = CurrentValueSubject<Ingredient?, Never>(nil)

    private let router: MealViewRouter

    init(meal: Meal,
         mealSelectionPublisher: AnyPublisher<String?, Never>,
         hasSubscriptionPublisher: AnyPublisher<Bool, Never>,
         selectedIngredientPublisher: AnyPublisher<(String, Ingredient), Never>,
         tappedWeightMealPublisher: AnyPublisher<String, Never>,
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
        observeSelectedIngredient(publisher: selectedIngredientPublisher)
        observeTappedWeightMealPublisher(publisher: tappedWeightMealPublisher)
    }

    var displayWeight: Double {
        editingWeight?.value ?? meal.mealItem.weight
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
        mealItem.type == .quickAdd
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

    func assignMeal(_ meal: Meal) {
        self.meal = meal
    }

    func ingredientViewModel(ingredient: Ingredient) -> IngredientViewModel {
        .init(input: .init(
            ingredient: ingredient,
            router: .init(navigator: router.navigator),
            statePublisher: $mealSelectedState
                .removeDuplicates()
                .map { $0.ingredient }
                .eraseToAnyPublisher(), 
            tappedWeightIngredientPublisher: tappedIngredientSubject.compactMap { $0 }.eraseToAnyPublisher()
        )) { [weak self] output in
            guard let self else { return }
            Task { [weak self] in
                try await self?.handle(ingredientOutput: output)
            }
        }
    }

    func weightTapped() {
        trackerService.track(.tapChangeWeight(context: .meal))
        if case .mealWeight = mealSelectedState {
            clearSelection()
            return
        }
        mealSelectedState = .mealWeight
        router.presentChangeWeightBanner(input: customKeyboardInput) { [weak self] output in
            guard let self else { return }
            Task { [weak self] in
                try await self?.handle(customKeyboardOutput: output)
            }
        }
        output(.banner(isBannerPresented: true, isKeyboardPresented: true))
    }

    func addIngredients() {
        mealSelectedState = .notSelected
        output(.banner(isBannerPresented: true, isKeyboardPresented: false))
        router.presentAddIngredientBanner(mealPublisher: $meal.eraseToAnyPublisher()) { [weak self] output in
            guard let self else { return }
            Task { [weak self] in
                try await self?.handle(addIngredientOutput: output)
            }
        }
    }

    @MainActor
    private func handle(addIngredientOutput output: AddIngredientOutput) async throws {
        switch output {
        case .search(let ingredientName):
            clearSelection()
            try await requestIngredients(with: ingredientName)
        case .scanBarcode(let isAccesGranted):
            clearSelection()
            barcodeScan(accessGranted: isAccesGranted)
        case .add(let mealItem):
            try await addIngredient(mealItem: mealItem)
        case .remove(let mealItem):
            try await removeIngredient(mealItem: mealItem)
        case .dismiss:
            clearSelection()
        case .present(let mealItem):
            router.presentCustomProduct(mealItem: mealItem) { [weak self] output in
                self?.handle(customProductOutput: output)
            }
        }
    }

    private func handle(customProductOutput output: CustomProductOutput) {
        Task { @MainActor in
            switch output {
            case .add(let mealItem):
                try await addIngredient(mealItem: mealItem)
                await router.dismiss()
                clearSelection()
            case .log(let mealItem):
                try await addIngredient(mealItem: mealItem)
                await router.dismiss(FoodLogRoute.self)
            }
        }
    }

    func clearSelection() {
        mealSelectedState = .notSelected
        output(.banner(isBannerPresented: false, isKeyboardPresented: false))
        router.dismissBanner(animation: .linear(duration: 0.5))
    }

    func tapMeal() {
        trackerService.track(.elementChosen(context: .meal))
        if case .delete = mealSelectedState {
            clearSelection()
            return
        }
        mealSelectedState = .delete
        presentMealDeleteBanner(meal)
        output(.banner(isBannerPresented: true, isKeyboardPresented: false))
    }

    func closeIngredientPlaceholder(with id: String) {
        Task {
            await removeIngredientPlaceholder(placeholderId: id)
        }
    }

    @MainActor
    private func addIngredient(mealItem: MealItem) async throws {
        if self.mealItem.type == .ingredient{
            let newMealItem = self.mealItem.convertIngredientToMealItem(with: [mealItem])
            let meal = meal.copyWith(mealItem: newMealItem)
            try await updateWithNewIngredietns(meal: meal)
            _ = try await mealUsageService.incrementUsage(newMealItem, mealType: meal.type)
            return
        }
        let meal = meal.copyWith(ingredients: [mealItem] + ingredients)
        try await updateWithNewIngredietns(meal: meal)
    }

    @MainActor
    private func removeIngredient(mealItem: MealItem) async throws {
        if self.mealItem.id == mealItem.id, self.mealItem.type == .ingredient{
            clearSelection()
            self.deleteMeal(meal)
            trackerService.track(.elementDeleted(context: .ingredient))
            self.output(.mealDeleted(meal: meal))
            return
        }
        let meal = meal.copyWith(ingredients: ingredients.filter { $0.id != mealItem.id })
        try await updateMeal(meal)
        self.output(.mealUpdated(meal: meal))
    }

    @MainActor
    private func updateWithNewIngredietns(meal: Meal) async throws {
        try await updateMeal(meal)
        self.output(.mealUpdated(meal: meal))
    }

    private func observeSelectedIngredient(publisher: AnyPublisher<(String, Ingredient), Never>) {
        publisher
            .filter { [weak self] ingredient in ingredient.0 == self?.meal.id }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, ingredient in
                this.tappedIngredientSubject.send(ingredient.1)
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func handle(customKeyboardOutput output: ContainerKeyboardOutput) async throws {
        switch output {
        case .valueChanged(let result):
            editingWeight = result
        case .add(let result):
            editingWeight = nil
            try await changeMealWeight(to: result)
            clearSelection()
        case .dismissed(let result):
            editingWeight = nil
            try await changeMealWeight(to: result)
        case .direction(let direction):
            try await changeKeyboardDirection(direction: direction)
        }
    }

    @MainActor
    private func handle(ingredientOutput: IngredientOutput) async throws {
        switch ingredientOutput {
        case .ingredientTapped(let ingredient):
            mealSelectedState = .ingredient(ingredient)
            output(.banner(isBannerPresented: true, isKeyboardPresented: false))
        case .weightTapped(let ingredient):
            mealSelectedState = .ingredientWeight(ingredient)
            output(.banner(isBannerPresented: true, isKeyboardPresented: true))
        case .deleted(let ingredient):
            let newIngredients = meal.mealItem.ingredients.filter { $0 != ingredient }
            try await updateIngredients(newIngredients: newIngredients)
        case .updated(newIngredient: let newIngredient, oldIngredient: let oldIngredient):
            guard let index = ingredients.firstIndex(of: oldIngredient) else { return }
            var newIngredients = ingredients
            newIngredients[index] = newIngredient
            try await updateIngredients(newIngredients: newIngredients)
        case .notSelected:
            clearSelection()
        case .direction(let direction):
            try await changeKeyboardDirection(direction: direction)
        }
    }

    @MainActor
    private func changeKeyboardDirection(direction: CustomKeyboardDirection) async throws {
        if let ingredient = mealSelectedState.ingredient,
           let index = ingredients.firstIndex(of: ingredient) {
            let nextIndex = direction == .up ? index - 1 : index + 1
            if nextIndex < 0 {
                weightTapped()
                return
            }
            if nextIndex >= ingredients.count {
                output(.selectedNext)
                return
            }
            tappedIngredientSubject.send(ingredients[nextIndex])
            return
        }

        if direction == .up {
            output(.selectPrev)
            return
        }
        if ingredients.count > 1 {
            if let editingWeight {
                try await changeMealWeight(to: editingWeight)
                self.editingWeight = nil
            }
            tappedIngredientSubject.send(ingredients[0])
            return
        }
        output(.selectedNext)
    }

    @MainActor
    private func updateIngredients(newIngredients: [Ingredient]) async throws {
        let newMeal = meal.copyWith(ingredients: newIngredients)
        try await updateMeal(newMeal)
        output(.mealUpdated(meal: newMeal))
    }

    @MainActor
    private func changeMealWeight(to newWeight: CustomKeyboardResult) async throws {
        if newWeight.value == mealItem.weight, newWeight.serving == mealItem.serving {
            return
        }
        let changedMealItem = meal.mealItem.updated(value: newWeight.value, serving: newWeight.serving)
        let changedMeal = meal.copyWith(mealItem: changedMealItem)
        try await updateMeal(changedMeal)
        output(.mealUpdated(meal: changedMeal))
        trackerService.track(.weightChanged(currentWeight: newWeight.value,
                                            previousWeight: meal.mealItem.weight,
                                            context: .meal))
    }

    @MainActor
    private func updateMeal(_ meal: Meal) async throws {
        let meal = try await mealService.save(meal: meal)
        self.meal = meal
    }

    private func deleteMeal(_ meal: Meal) {
        Task { [weak self] in
            guard let self else { return }
            try await self.mealService.delete(byId: meal.id)
            try await mealUsageService.decrementUsage(meal.mealItem, mealType: meal.type)
        }
    }

    private func observeMealSelectionPublisher(publisher: AnyPublisher<String?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, id in
                if id != this.meal.id {
                    this.mealSelectedState = .notSelected
                }
            }
            .store(in: &cancellables)
    }

    private func observeTappedWeightMealPublisher(publisher: AnyPublisher<String, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, id in
                if id == this.meal.id {
                    this.weightTapped()
                }
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

        $mealSelectedState
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, state in
                this.output(.ingredientSelected(state.ingredient))
            }
            .store(in: &cancellables)
    }

    var currentServing: MealServing {
        editingWeight?.serving ?? mealItem.serving
    }

    private var customKeyboardInput: CustomKeyboardInput {
        CustomKeyboardInput(
            title: mealItem.mealName,
            text: "\(mealItem.weight)",
            servings: mealItem.servings,
            currentServing: currentServing,
            isPresentedPublisher: $mealSelectedState.map { $0 != .notSelected }.eraseToAnyPublisher()
        )
    }
}

// MARK: - Request Ingredients
extension MealViewViewModel {
    private func requestIngredients(with text: String) async throws {
        let placeholder = await prepareIngredientPlaceholder(text: text)
        let ingredients = try await calorieCounterService.ingredients(request: text)
        try await removePlaceholderAndUpdateIngredients(placeholderId: placeholder.id, ingredients: ingredients)
    }

    private func searchIngredient(barcode: String) async throws {
        let placeholder = await prepareIngredientPlaceholder(text: barcode)
        guard let ingredient = try await foodSearchService.searchIngredient(barcode: barcode) else {
            trackBarcodeScanned(isSucces: false, productName: nil)
            await setNotFoundForIngredientPlaceholder(placeholderId: placeholder.id)
            return
        }
        try await removePlaceholderAndUpdateIngredients(placeholderId: placeholder.id, ingredients: [ingredient])
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
    private func removePlaceholderAndUpdateIngredients(placeholderId: String, ingredients: [Ingredient]) async throws {
        removeIngredientPlaceholder(placeholderId: placeholderId)
        if self.mealItem.type == .ingredient {
            let newMealItem = self.mealItem.convertIngredientToMealItem(with: ingredients)
            let meal = meal.copyWith(mealItem: newMealItem)
            _ = try await mealUsageService.incrementUsage(newMealItem, mealType: meal.type)
            try await updateWithNewIngredietns(meal: meal)
            return
        }
        let meal = meal.copyWith(ingredients: ingredients + mealItem.ingredients)
        try await updateWithNewIngredietns(meal: meal)
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
