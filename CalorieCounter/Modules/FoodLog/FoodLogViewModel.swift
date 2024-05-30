//  
//  FoodLogViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies
import Combine
import Photos

class FoodLogViewModel: BaseViewModel<FoodLogOutput> {

    @Dependency(\.calorieCounterService) private var calorieCounterService
    @Dependency(\.mealService) private var mealService
    @Dependency(\.foodSearchService) private var foodSearchService
    @Dependency(\.freeUsageService) private var freeUsageService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.requestReviewService) private var requestReviewService
    @Dependency(\.mealUsageService) private var mealUsageService
    @Dependency(\.cameraAccessService) private var cameraAccessService

    var router: FoodLogRouter!
    @Published var mealType: MealType
    @Published var logItems: [FoodLogItem] = []
    @Published var mealSelectedState: MealSelectedState = .notSelected
    @Published var hasSubscription: Bool
    @Published var isKeyboardFocused: Bool
    @Published var isSuggestionsPresented: Bool
    @Published var logType: LogType = .log
    @Published var quickAddMeal: Meal?
    @Published var mealRequest = ""
    @Published var isQuickAddPresented = false
    private let dayDate: Date
    private let context: FoodLogContext
    private var isBarcodeScanFinishedSuccess = false
    @Atomic private var mealsCountInDay: Int
    @Published var ingredientPlaceholders: [String: [MealPlaceholder]] = [:]
    @Published private var votings: [String: MealVoting] = [:]
    private var votingsTimer: [String: TimeInterval] = [:]
    private var dismissSuggestionsSubject = PassthroughSubject<Void, Never>()

    var foodLogContext: FoodLogTextFieldContext {
        switch mealSelectedState {
        case .addIngredients(let meal):
            .addIngredients(meal)
        default:
            .addMeal
        }
    }

    var tappedWeightIngredient: Ingredient? {
        guard case let .ingredientWeight(_, ingredient) = mealSelectedState else {
            return nil
        }
        return ingredient
    }

    var tappedWeightMeal: Meal? {
        guard case let .mealWeight(meal) = mealSelectedState else {
            return nil
        }
        return meal
    }
    
    init(input: FoodLogInput, output: @escaping FoodLogOutputBlock) {
        mealType = input.mealType
        dayDate = input.dayDate
        context = input.context
        isKeyboardFocused = input.context.isKeyboardFocused
        isSuggestionsPresented = input.context.isKeyboardFocused
        hasSubscription = input.hasSubscription
        mealsCountInDay = input.mealsCountInDay
        super.init(output: output)
        loadMeals(initialData: input.initialMeal)

        subscribeLogTypeEvents()
    }

    var nutritionProfile: NutritionProfile {
        logItems.reduce(.empty) {
            switch $1 {
            case .meal(let meal):
                return $0 ++ meal.mealItem.nutritionProfile
            case .placeholder, .notFoundBarcode:
                return $0
            }
        }
    }

    var foodSuggestionsInput: FoodSuggestionsInput {
        .init(mealPublisher: $logItems.map { $0.compactMap { $0.meal?.mealItem } }.eraseToAnyPublisher(),
              mealType: mealType,
              mealRequestPublisher: $mealRequest.eraseToAnyPublisher(),
              isPresented: isKeyboardFocused,
              collapsePublisher: dismissSuggestionsSubject.eraseToAnyPublisher(), 
              searchRequest: mealRequest,
              canShowFavorites: logType == .log)
    }

    func onViewAppear() {
        if context == .barcode {
            Task {
                let cameraAccessGranted = await cameraAccessService.requestAccess()
                await MainActor.run {
                    barcodeScan(accessGranted: cameraAccessGranted)
                }
            }
        }
    }

    func onFocusChanged(_ isFocused: Bool) {
        if case .addIngredients = mealSelectedState, !isFocused {
            mealSelectedState = .notSelected
            isQuickAddPresented = false
            isKeyboardFocused = false
        }
    }

    func changeIngredientWeight(to newWeight: Double) {
        guard
            case let .ingredientWeight(meal, ingredient) = mealSelectedState,
            Int(ingredient.weight) != Int(newWeight),
            let ingredientIndex = meal.mealItem.ingredients.firstIndex(of: ingredient),
            let mealIndex = mealIndex(of: meal) else {
            clearSelection()
            return
        }
        let changedIngredient = Ingredient(name: ingredient.name,
                                           brandTitle: ingredient.brandTitle,
                                           weight: newWeight,
                                           normalizedProfile: ingredient.normalizedProfile)
        var newIngredients = meal.mealItem.ingredients
        newIngredients[ingredientIndex] = changedIngredient
        let changedMeal = meal.copyWith(ingredients: newIngredients)
        updateMeal(changedMeal)
        logItems[mealIndex] = .meal(changedMeal)
        clearSelection()
        trackerService.track(.weightChanged(currentWeight: newWeight,
                                            previousWeight: ingredient.weight,
                                            context: .ingredient))
    }

    private func mealIndex(of meal: Meal) -> Int? {
        logItems.firstIndex(where: { $0.meal?.id == meal.id })
    }

    func changeMealWeight(to newWeight: Double) {
        guard case let .mealWeight(meal) = mealSelectedState,
              Int(newWeight) != Int(meal.mealItem.weight),
              let mealIndex = mealIndex(of: meal) else {
            clearSelection()
            return
        }
        let difference = meal.mealItem.weight == 0 ? 0 : newWeight / meal.mealItem.weight

        let ingredients = meal.mealItem.ingredients
        let newIngredients = ingredients.map {
            Ingredient(name: $0.name,
                       brandTitle: $0.brandTitle,
                       weight: difference != 0 ? $0.weight * difference : newWeight / Double(ingredients.count),
                       normalizedProfile: $0.normalizedProfile)
        }
        let changedMeal = meal.copyWith(ingredients: newIngredients)
        updateMeal(changedMeal)
        logItems[mealIndex] = .meal(changedMeal)
        clearSelection()
        trackerService.track(.weightChanged(currentWeight: newWeight,
                                            previousWeight: meal.mealItem.weight,
                                            context: .meal))
    }

    func setMealToDelete(_ meal: Meal) {
        trackerService.track(.elementChosen(context: .meal))
        if case .delete(let prevMeal) = mealSelectedState, prevMeal == meal {
            clearMealSelection()
            return
        }
        hideKeyboard()
        clearSelection()
        mealSelectedState = .delete(meal)
        presentMealDeleteBanner(meal)
    }

    func changeMealType() {
        router.presentMealTypePicker(currentMealType: mealType) { [weak self] type in
            DispatchQueue.main.async {
                self?.changeMealType(to: type)
            }
        }
    }

    func remove(placeholder: MealPlaceholder) {
        logItems.removeAll { $0.placeholderId == placeholder.id }
    }

    func dismiss() {
        #if !DEBUG
        if !logItems.isEmpty {
            requestReviewService.requestAppStoreReview()
        }
        #endif
        hideKeyboard()
        output(.closed)
        router.dismiss()
    }

    func clearSelection() {
        mealSelectedState = .notSelected
        router.dismissBanner()
    }

    func mealViewInput(for meal: Meal) -> MealViewInput {
        if meal == mealSelectedState.meal {
            return .init(
                meal: meal.mealItem,
                ingredientPlaceholders: ingredientPlaceholders[meal.id] ?? [],
                isTapped: mealSelectedState.isMealSelected || hasIngredientPlaceholder(for: meal),
                isWeightTapped: mealSelectedState.isWeightEditing ? mealSelectedState.ingredient == nil : false,
                tappedIngredient: mealSelectedState.isWeightEditing ? nil : mealSelectedState.ingredient,
                tappedWeightIngredient: mealSelectedState.isWeightEditing ? mealSelectedState.ingredient : nil, 
                voting: nil
            )
        }
        return .init(
            meal: meal.mealItem,
            ingredientPlaceholders: ingredientPlaceholders[meal.id] ?? [],
            isTapped: hasIngredientPlaceholder(for: meal),
            isWeightTapped: false,
            tappedIngredient: nil,
            tappedWeightIngredient: nil, 
            voting: voting(for: meal)
        )
    }

    func voting(for meal: Meal) -> MealVoting? {
        if let voting = votings[meal.id] {
            return voting
        }
        if meal.voting != .notVoted || meal.voting == .disabled {
            return nil
        }
        return meal.voting
    }

    func closeChip() {
            switch logType {
            case .log:
                break
            case .history:
                withAnimation {
                    logType = .log
                }

            case .quickAdd:
                quickAddMeal = nil
                isQuickAddPresented = false
                withAnimation(.linear(duration: 0.35)) {
                    logType = .log
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                    self.isSuggestionsPresented = true
                    self.isKeyboardFocused = true
                }
            case .addRecipe:
                break
            }
    }

    @MainActor
    private func clearLogTypeQuickAddState() async {
        logType = .log
        isQuickAddPresented = false
        isSuggestionsPresented = false
        isKeyboardFocused = false
    }

    @MainActor
    private func clearQuickAddMeal() async {
        quickAddMeal = nil
        isQuickAddPresented = false
        isKeyboardFocused = true
        isSuggestionsPresented = true
    }

    func handle(quickAddOutput: QuickAddOutput) {
        switch quickAddOutput {
        case .created(let meal):
            dismissSuggestionsSubject.send()
            Task {
                var editedMeal = meal.copyWith(type: mealType)
                editedMeal.dayDate = dayDate
                let savedMeal = try await mealService.save(meal: editedMeal)
                await updateOrInsert(meal: savedMeal)
                await clearLogTypeQuickAddState()
            }
        case .updated(let meal):
            dismissSuggestionsSubject.send()
            Task {
                let saved = try await mealService.save(meal: meal)
                await update(meal: saved)
                await clearLogTypeQuickAddState()
            }
        case .dismiss:
            break
        }
    }

    func handle(mealViewOutput output: MealViewOutput, meal: Meal) {
        switch output {
        case .ingredientTap(let ingredient):
            ingredientTapped(ingredient, meal: meal)
        case .ingredientWeightTap(let ingredient):
            ingredientWeightTapped(ingredient, meal: meal)
        case .mealWeightTap:
            mealWeightTapped(meal)
        case .addIngredientsTap:
            addIngredientsTapped(for: meal)
        case .onIngredientPlaceholderClose(let placeholderId):
            Task {
                await removeIngredientPlaceholder(placeholderId: placeholderId, for: meal)
            }
        case .vote(let voting):
            switch voting {
            case .notVoted, .disabled:
                break
            case .like:
                trackTapLike()
            case .dislike:
                trackTapDislike()
            }
            vote(voting: voting, for: meal)
        case .tap:
            setMealToDelete(meal)
        }
    }

    func vote(voting: MealVoting, for meal: Meal) {
        votings[meal.id] = voting
        votingsTimer[meal.id] = TimeInterval.second * 3
        startVotingTimer()
    }

    var votingTimer: Timer?

    func startVotingTimer() {
        if votingTimer == nil {
            votingTimer = Timer.scheduledTimer(withTimeInterval: .second, repeats: true) { [weak self] timer in
                self?.decreaseVotingTime()
                self?.checkVotings()
            }
        }
    }

    private func decreaseVotingTime() {
        votingsTimer.keys.forEach { id in
            votingsTimer[id] = (votingsTimer[id] ?? 0) - TimeInterval.second
        }
    }

    private func subscribeLogTypeEvents() {
        $logType
            .receive(on: DispatchQueue.main)
            .filter { $0 == .quickAdd }
            .sink(with: self) { this, _ in
                this.isQuickAddPresented = true
            }
            .store(in: &cancellables)

        $logType
            .receive(on: DispatchQueue.main)
            .filter { $0 == .history }
            .sink(with: self) { this, _ in
                this.isKeyboardFocused = true
            }
            .store(in: &cancellables)

        $isQuickAddPresented
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink(with: self) { this, value in
                this.isSuggestionsPresented = false
                this.isKeyboardFocused = true
            }
            .store(in: &cancellables)

        $isSuggestionsPresented
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink(with: self) { this, value in
                this.isQuickAddPresented = false
            }
            .store(in: &cancellables)
    }

    private func checkVotings() {
        votingsTimer.forEach { (id, time) in
            if time <= 0 {
                votingsTimer[id] = nil
                if let voting = votings[id] {
                    votings[id] = nil
                    update(mealId: id, voting: voting)
                }
            }
        }

        if let votingTimer, votings.isEmpty {
            votingTimer.invalidate()
            self.votingTimer = nil
        }
    }

    private func update(mealId: String, voting: MealVoting) {
        Task { [weak self] in
            guard var meal = self?.meal(byId: mealId) else {
                return
            }
            meal.voting = voting

            guard let savedMeal = try await self?.mealService.save(meal: meal) else {
                return
            }
            await self?.update(meal: savedMeal)

            // TODO: - send analytics event
            self?.trackMealFeedback(meal: savedMeal)
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

    private func meal(byId mealId: String) -> Meal? {
        guard let index = logItems.firstIndex(where: { $0.meal?.id == mealId }),
              let meal = logItems[index].meal else {
            return nil
        }
        return meal
    }

    private func loadMeals(initialData: [Meal]) {
        Task { [weak self] in
            guard let self else { return }
            await replaceMeals(initialData)
            let meals = try await mealService.meals(forDay: self.dayDate, type: self.mealType)
            await self.replaceMeals(meals)
        }
    }

    private func updateMeal(_ meal: Meal) {
        Task { [weak self] in
            try await self?.mealService.save(meal: meal)
        }
    }

    @MainActor
    private func update(meal: Meal) {
        if let index = mealIndex(of: meal) {
            logItems[index] = .meal(meal)
        }
    }

    @MainActor
    private func updateOrInsert(meal: Meal) {
        if let index = mealIndex(of: meal) {
            logItems[index] = .meal(meal)
        } else {
            logItems.insert(.meal(meal), at: 0)
        }
    }

    @MainActor
    private func replaceMeals(_ meals: [Meal]) {
        logItems = meals.map { .meal($0) }
    }

    private func changeMealType(to newType: MealType) {
        trackerService.track(.containerSwitched(currentContainer: newType.rawValue,
                                                previousContainer: mealType.rawValue))
        mealType = newType
        loadMeals(initialData: [])
    }

    private func addIngredientsTapped(for meal: Meal) {
        clearSelection()
        isKeyboardFocused = true
        isQuickAddPresented = false
        mealSelectedState = .addIngredients(meal)
    }

    private func mealWeightTapped(_ meal: Meal) {
        trackerService.track(.tapChangeWeight(context: .meal))
        if case let .mealWeight(selectedMeal) = mealSelectedState, meal == selectedMeal {
            clearSelection()
            return
        }
        clearSelection()
        mealSelectedState = .mealWeight(meal)
    }

    private func ingredientWeightTapped(_ ingredient: Ingredient, meal: Meal) {
        trackerService.track(.tapChangeWeight(context: .ingredient))
        if case let .ingredientWeight(_, selectedIngredient) = mealSelectedState, ingredient == selectedIngredient {
            clearSelection()
            return
        }
        clearSelection()
        mealSelectedState = .ingredientWeight(meal, ingredient)
    }

    private func ingredientTapped(_ ingredient: Ingredient, meal: Meal) {
        trackerService.track(.elementChosen(context: .ingredient))
        if case let .ingredient(_, selectedIngredient) = mealSelectedState, ingredient == selectedIngredient {
            clearSelection()
            return
        }
        hideKeyboard()
        clearSelection()
        mealSelectedState = .ingredient(meal, ingredient)
        presentIngredientDeleteBanner(meal: meal, ingredient: ingredient)
    }

    private func presentIngredientDeleteBanner(meal: Meal, ingredient: Ingredient) {
        router.presentDeleteBanner(editType: .deleteIngredient) { [weak self] in
            self?.clearSelection()
        } onDelete: { [weak self] in
            guard let self else { return }
            self.clearSelection()
            guard let index = logItems.firstIndex(where: { $0.meal?.id == meal.id }),
                  let meal = logItems[index].meal else {
                return
            }
            let newIngredients = meal.mealItem.ingredients.filter { $0 != ingredient }
            let newMeal = meal.copyWith(ingredients: newIngredients)
            updateMeal(newMeal)
            logItems[index] = .meal(newMeal)
            trackerService.track(.elementDeleted(context: .ingredient))
        } onEdit: {}
    }

    @MainActor
    func deselectAndDismissKeyboard() {
        isSuggestionsPresented = false
        isQuickAddPresented = false
        isKeyboardFocused = false
        mealSelectedState = .notSelected
    }

    func handle(foodSuggestionsOutput output: FoodSuggestionsOutput) {
        switch output {
        case .add(let mealItem):
            let meal = Meal(type: mealType,
                            dayDate: dayDate,
                            mealItem: mealItem,
                            voting: .disabled)
            logItems.insert(.meal(meal), at: 0)
            Task {
                try await save(meals: [meal])
            }
            mealRequest = ""
        case .remove(let mealItem):
            guard let mealIndex = logItems.firstIndex(where: { $0.meal?.mealItem.id == mealItem.id }),
                  let meal = logItems[mealIndex].meal else {
                return
            }
            deleteMeal(meal)
            logItems.remove(at: mealIndex)
            decrementMealsCount()
        case .togglePresented(let isPresented):
            isKeyboardFocused = isPresented
            isSuggestionsPresented = isPresented
        }
    }

    private func presentMealDeleteBanner(_ meal: Meal) {
        router.presentDeleteBanner(editType: meal.isQuickAdded ? .quickAddMeal : .deleteMeal) { [weak self] in
            self?.clearMealSelection()
        } onDelete: { [weak self] in
            guard let self else { return }
            self.clearMealSelection()
            self.deleteMeal(meal)
            logItems = logItems.filter { $0.meal?.id != meal.id }
            trackerService.track(.elementDeleted(context: .meal))
            decrementMealsCount()
        } onEdit: { [weak self] in
            guard let self else { return }
            self.clearMealSelection()
            self.quickAddMeal = meal
            self.logType = .quickAdd
            self.isQuickAddPresented = true
        }
    }

    func clearMealSelection() {
        mealSelectedState = .notSelected
        router.dismissBanner()
    }

    @MainActor
    private func replacePlaceholder(with meals: [Meal], placeholderId: String, mealType: MealType) {
        if let index = logItems.firstIndex(where: { $0.placeholderId == placeholderId }) {
            logItems.replaceSubrange(index...index, with: meals.map { .meal($0) })
            return
        }
        if self.mealType == mealType {
            logItems.insert(contentsOf: meals.map { .meal($0) }, at: 0)
        }
    }

    @MainActor
    private func updateNotFoundBarcode(placeholderId: String) {
        if let index = logItems.firstIndex(where: { $0.placeholderId == placeholderId }),
            case let .placeholder(placeholder) = logItems[index] {
            logItems.replaceSubrange(index...index, with: [.notFoundBarcode(placeholder)])
            return
        }
    }

    @MainActor
    private func appendPlaceholder(_ placeholder: MealPlaceholder) {
        logItems.insert(.placeholder(placeholder), at: 0)
        dismissSuggestionsSubject.send()
    }

    @MainActor
    private func appendIngredientPlaceholder(_ placeholder: MealPlaceholder, for meal: Meal) {
        dismissSuggestionsSubject.send()
        var ings = ingredientPlaceholders[meal.id] ?? [MealPlaceholder]()
        ings.append(placeholder)
        ingredientPlaceholders[meal.id] = ings
    }

    @MainActor
    private func removeIngredientPlaceholder(placeholderId: String, for meal: Meal) {
        var ings = ingredientPlaceholders[meal.id] ?? [MealPlaceholder]()
        ings.removeAll { $0.id == placeholderId }
        ingredientPlaceholders[meal.id] = ings
    }

    @MainActor
    private func setNotFoundForIngredientPlaceholder(placeholderId: String, for meal: Meal) {
        var ings = ingredientPlaceholders[meal.id] ?? [MealPlaceholder]()
        guard 
            var ing = ings.first(where: { $0.id == placeholderId }),
            let index = ings.firstIndex(where: { $0.id == placeholderId })
        else {
            return
        }
        ing.notFound = true
        ings.replaceSubrange(index...index, with: [ing])
        ingredientPlaceholders[meal.id] = ings
    }

    private func hasIngredientPlaceholder(for meal: Meal) -> Bool {
        !(ingredientPlaceholders[meal.id] ?? []).isEmpty
    }

    private func deleteMeal(_ meal: Meal) {
        Task { [weak self] in
            guard let self else { return }
            try await self.mealService.delete(byId: meal.id)
            try await mealUsageService.decrementUsage(meal.mealItem, mealType: mealType)
        }
    }

    private func incrementMealsCount() {
        if mealsCountInDay == 0 {
            userPropertyService.incrementProperty(property: "days_logged_count", value: 1)
        }
        mealsCountInDay += 1
    }

    private func decrementMealsCount() {
        mealsCountInDay -= 1
        if mealsCountInDay == 0 {
            userPropertyService.decrementProperty(property: "days_logged_count", value: 1)
        }
    }
}

// MARK: - API Chat GPT functions
extension FoodLogViewModel {
    func logMeal(text: String) {
        switch foodLogContext {
        case .addMeal:
            Task { [weak self] in
                guard let self else { return }
                try await requestMeal(text: text)
            }
        case .addIngredients(let meal):
            Task { [weak self] in
                guard let self else { return }
                try await requestIngredients(for: meal, with: text)
            }
        }
    }

    private func requestIngredients(for meal: Meal, with text: String) async throws {
        await deselectAndDismissKeyboard()
        let placeholder = MealPlaceholder(mealText: text)
        await appendIngredientPlaceholder(placeholder, for: meal)
        trackerService.track(.entrySent)
        let ingredients = try await ingredients(request: text)
        await removeIngredientPlaceholder(placeholderId: placeholder.id, for: meal)
        let newIngredients = ingredients + meal.mealItem.ingredients
        let meal = meal.copyWith(ingredients: newIngredients)
        try await mealService.save(meals: [meal])
        await update(meal: meal)
    }

    private func requestMeal(text: String) async throws {
        await MainActor.run {
            isSuggestionsPresented = false
        }
        let placeholder = MealPlaceholder(mealText: text)
        await appendPlaceholder(placeholder)
        trackerService.track(.entrySent)
        let meals = try await meals(request: text, type: mealType)
        await replacePlaceholder(with: meals, placeholderId: placeholder.id, mealType: mealType)
        trackerService.track(.mealAdded(ingredientsCounts: meals.flatMap { $0.mealItem.ingredients }.count))
        try await save(meals: meals)
    }

    private func save(meals: [Meal]) async throws {
        try await mealService.save(meals: meals)
        for meal in meals {
            _ = try await mealUsageService.incrementUsage(meal.mealItem, mealType: mealType)
        }
        freeUsageService.insertDate(date: dayDate)
        incrementMealsCount()
    }

    private func meals(request: String, type: MealType) async throws -> [Meal] {
        let mealItems = try await calorieCounterService.food(request: request)
        return mealItems.map { Meal(type: type, dayDate: dayDate, mealItem: $0, voting: .notVoted) }
    }

    private func ingredients(request: String) async throws -> [Ingredient] {
        let ingredients = try await calorieCounterService.ingredients(request: request)
        return ingredients
    }
}

// MARK: - Barcode functions
extension FoodLogViewModel {
    func logMeal(barcode: String) {
        switch foodLogContext {
        case .addMeal:
            Task {
                try await searchMeal(barcode: barcode)
            }
        case .addIngredients(let meal):
            Task {
                try await searchIngredient(for: meal, barcode: barcode)
            }
        }
    }

    func barcodeScan(accessGranted: Bool) {
        guard accessGranted else {
            router.presentCameraAccessAlert()
            return
        }
        isBarcodeScanFinishedSuccess = true
        guard hasSubscription else {
            presentPaywall { [weak self] in
                self?.barcodeScan(accessGranted: accessGranted)
            }
            return
        }
        router.presentBarcodeScanner { [weak self] output in
            self?.onBarcode(output: output)
        }
    }

    private func searchMeal(barcode: String) async throws {
        await MainActor.run {
            isSuggestionsPresented = false
        }
        let placeholder = MealPlaceholder(mealText: barcode)
        await appendPlaceholder(placeholder)
        guard let mealItem = try await foodSearchService.search(barcode: barcode) else {
            trackBarcodeScanned(isSucces: false, productName: nil)
            await updateNotFoundBarcode(placeholderId: placeholder.id)
            return
        }
        let meals = [Meal(type: mealType, dayDate: dayDate, mealItem: mealItem, voting: .disabled)]
        trackBarcodeScanned(isSucces: true, productName: mealItem.name)
        await replacePlaceholder(with: meals, placeholderId: placeholder.id, mealType: mealType)
        try await mealService.save(meals: meals)
        for meal in meals {
            _ = try await mealUsageService.incrementUsage(meal.mealItem, mealType: mealType)
        }
        freeUsageService.insertDate(date: dayDate)
        incrementMealsCount()
    }

    private func searchIngredient(for meal: Meal, barcode: String) async throws {
        await deselectAndDismissKeyboard()
        let placeholder = MealPlaceholder(mealText: barcode)
        await appendIngredientPlaceholder(placeholder, for: meal)
        trackerService.track(.entrySent)

        guard let ingredient = try await foodSearchService.searchIngredient(barcode: barcode) else {
            trackBarcodeScanned(isSucces: false, productName: nil)
            await setNotFoundForIngredientPlaceholder(placeholderId: placeholder.id, for: meal)
            return
        }
        await removeIngredientPlaceholder(placeholderId: placeholder.id, for: meal)

        let newIngredients = [ingredient] + meal.mealItem.ingredients
        let meal = meal.copyWith(ingredients: newIngredients)
        try await mealService.save(meals: [meal])
        await update(meal: meal)
    }

    private func onBarcode(output: BarcodeOutput) {
        router.dismiss()
        switch output {
        case .barcode(let barcode):
            logMeal(barcode: barcode)
            isBarcodeScanFinishedSuccess = true
        case .close:
            if !isBarcodeScanFinishedSuccess {
                dismiss()
            }
        }
    }
}

// MARK: - Analytics
extension FoodLogViewModel {
    func trackBarcodeScannerOpen() {
        trackerService.track(.tapScanBarcode(context: BarcodeScannerOpenContext.container.rawValue))
    }

    func trackTapLike() {
        trackerService.track(.tapLike)
    }

    func trackTapDislike() {
        trackerService.track(.tapDislike)
    }

    func trackMealFeedback(meal: Meal) {
        guard meal.voting == .like || meal.voting == .dislike else {
            return
        }
        trackerService.track(.mealFeedbackSent(
            type: meal.voting == .like ? "like" : "dislike",
            name: meal.mealItem.mealName,
            calories: "\(Int(meal.calories))",
            carbs: "\(Int(meal.mealItem.nutritionProfile.carbohydrates))",
            fat: "\(Int(meal.mealItem.nutritionProfile.fats))",
            protein: "\(Int(meal.mealItem.nutritionProfile.proteins))",
            ingredients: "\(meal.mealItem.nameFromIngredients)")
        )
        if meal.voting == .like {
            userPropertyService.incrementProperty(property: "feedback_like_count", value: 1)
        } else {
            userPropertyService.incrementProperty(property: "feedback_dislike_count", value: 1)
        }
    }

    func trackTapFinishLogging() {
        trackerService.track(.tapFinishLogging)
    }

    func trackTapBackButton() {
        trackerService.track(.tapBackToFoodLog)
    }

    private func trackBarcodeScanned(isSucces: Bool, productName: String?) {
        trackerService.track(.barcodeScanned(result: isSucces ? "success" : "fail",
                                             productName: productName))
    }
}
