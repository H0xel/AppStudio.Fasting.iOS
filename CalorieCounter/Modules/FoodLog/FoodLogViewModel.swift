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
    @Published var hasSubscription: Bool
    @Published var isBannerPresented = false
    @Published var selectedMealId: String?
    let dayDate: Date
    private let context: FoodLogContext
    @Atomic private var mealsCountInDay: Int
    private let editQuickAddSubject = PassthroughSubject<Meal, Never>()
    private let scrollToTopSubject = PassthroughSubject<Void, Never>()

    init(input: FoodLogInput, output: @escaping FoodLogOutputBlock) {
        mealType = input.mealType
        dayDate = input.dayDate
        context = input.context
        hasSubscription = input.hasSubscription
        mealsCountInDay = input.mealsCountInDay
        super.init(output: output)
        loadMeals(initialData: input.initialMeal)
    }

    var scrollToTopPublisher: AnyPublisher<Void, Never> {
        scrollToTopSubject.eraseToAnyPublisher()
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

    var inputViewModel: FoodLogInputViewModel {
        .init(
            router: router,
            input: .init(
                mealType: mealType,
                dayDate: dayDate,
                isKeyboardFocused: context.isKeyboardFocused,
                hasSubscription: hasSubscription,
                shouldPresentScannerOnAppear: context == .barcode,
                mealPublisher: $logItems.map { $0.compactMap { $0.meal?.mealItem } }.eraseToAnyPublisher(),
                editQuickAddPublisher: editQuickAddSubject.eraseToAnyPublisher())
        ) { [weak self] output in
            guard let self else { return }
            Task { [weak self] in
                try await self?.handle(logInputOutput: output)
            }
        }
    }

    func mealViewModel(meal: Meal) -> MealViewViewModel {
        .init(
            meal: meal,
            mealSelectionPublisher: $selectedMealId.compactMap { $0 }.eraseToAnyPublisher(), 
            hasSubscriptionPublisher: $hasSubscription.eraseToAnyPublisher(),
            router: .init(navigator: router.navigator)
        ) { [weak self] output in
            self?.handle(mealViewOutput: output)
        }
    }

    @MainActor
    private func handle(logInputOutput output: FoodLogInputOutput) async throws {
        switch output {
        case .insert(let meal):
            logItems.insert(.meal(meal), at: 0)
            try await save(meals: [meal])
        case let .save(meals, placeholderId):
            replacePlaceholder(with: meals, placeholderId: placeholderId, mealType: mealType)
            try await save(meals: meals)
        case .remove(let mealItem):
            guard let mealIndex = logItems.firstIndex(where: { $0.meal?.mealItem.id == mealItem.id }),
                  let meal = logItems[mealIndex].meal else {
                return
            }
            deleteMeal(meal)
            logItems.remove(at: mealIndex)
            decrementMealsCount()
        case .appendPlaceholder(let mealPlaceholder):
            appendPlaceholder(mealPlaceholder)
        case .dismiss:
            await router.dismiss()
        case .notFoundBarcode(let placeholderId):
            updateNotFoundBarcode(placeholderId: placeholderId)
        case .hasSubscription(let hasSubscription):
            self.hasSubscription = hasSubscription
        case .update(let meal):
            try await mealService.save(meals: [meal])
            update(meal: meal)
        case .onFocus:
            scrollToTopSubject.send()
        }
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

    func handle(mealViewOutput output: MealViewOutput) {
        switch output {
        case .mealUpdated(let meal):
            mealUpdated(meal: meal)
        case .mealDeleted(meal: let meal):
            logItems = logItems.filter { $0.meal?.id != meal.id }
            decrementMealsCount()
        case .banner(let isPresented):
            isBannerPresented = isPresented
        case .selected(let mealId):
            selectedMealId = mealId
        case .editQuickAdd(let meal):
            editQuickAddSubject.send(meal)
        case .hasSubscription(let hasSubscription):
            self.hasSubscription = hasSubscription
        }
    }

    private func deleteMeal(_ meal: Meal) {
        Task { [weak self] in
            guard let self else { return }
            try await self.mealService.delete(byId: meal.id)
            try await mealUsageService.decrementUsage(meal.mealItem, mealType: meal.type)
        }
    }

    private func mealIndex(of meal: Meal) -> Int? {
        logItems.firstIndex(where: { $0.meal?.id == meal.id })
    }

    private func mealUpdated(meal: Meal) {
        guard let index = logItems.firstIndex(where: { $0.meal?.id == meal.id }) else {
            return
        }
        logItems[index] = .meal(meal)
    }

    private func loadMeals(initialData: [Meal]) {
        Task { [weak self] in
            guard let self else { return }
            await replaceMeals(initialData)
            let meals = try await mealService.meals(forDay: self.dayDate, type: self.mealType)
            await self.replaceMeals(meals)
        }
    }

    @MainActor
    private func update(meal: Meal) {
        if let index = mealIndex(of: meal) {
            logItems[index] = .meal(meal)
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
    private func save(meals: [Meal]) async throws {
        try await mealService.save(meals: meals)
        for meal in meals {
            _ = try await mealUsageService.incrementUsage(meal.mealItem, mealType: mealType)
        }
        freeUsageService.insertDate(date: dayDate)
        incrementMealsCount()
    }
}

// MARK: - Analytics
extension FoodLogViewModel {
    func trackTapBackButton() {
        trackerService.track(.tapBackToFoodLog)
    }
}
