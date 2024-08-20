//  
//  CustomProductViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import Combine
import Dependencies
import SwiftUI
import WaterCounter

class CustomProductViewModel: BaseViewModel<CustomProductOutput> {

    @Published private var mealItem: MealItem
    @Published var isToolbarPresented = false
    @Published var keyboardResult: CustomKeyboardResult!
    @Dependency(\.mealItemService) private var mealItemService
    @Dependency(\.mealUsageService) private var mealUsageService
    let router: CustomProductRouter

    init(input: CustomProductInput, router: CustomProductRouter, output: @escaping CustomProductOutputBlock) {
        self.router = router
        let mealItem = input.mealItem
        self.mealItem = mealItem
        super.init(output: output)
        configureKeyboardResult(mealItem: mealItem)
        presentKeyboard(animation: nil)
    }

    var productName: String {
        mealItem.name
    }

    var servingMultiplier: Double {
        keyboardResult.servingMultiplier
    }

    var brandName: String? {
        mealItem.brandSubtitle
    }

    var ingredients: [IngredientStruct] {
        mealItem.ingredients.count > 1 ? mealItem.ingredients : []
    }

    var nutritionProfile: NutritionProfile {
        if mealItem.ingredients.count > 0 {
            return mealItem.nutritionProfile.calculate(servingMultiplier: keyboardResult.servingMultiplier)
        }
        return mealItem.normalizedProfile.calculate(servingMultiplier: keyboardResult.servingMultiplier)
    }

    var serving: MealServing {
        keyboardResult.serving
    }

    var servingValue: Double {
        keyboardResult.value
    }

    var mlValue: Double? {
        if let mlServing = mealItem.mealServings.first(where: { $0.measure == WaterUnits.liters.unitsTitle }) {
            return serving.convert(value: servingValue, to: mlServing)
        }
        return nil
    }

    var canShowSettings: Bool {
        mealItem.type == .product
    }

    func dismiss() {
        router.dismiss()
    }

    func presentSettings() {
        if isToolbarPresented {
            isToolbarPresented = false
            presentKeyboard(animation: .linear(duration: 0.15))
            return
        }
        router.dismissBanner(animation: .linear(duration: 0.15))
        isToolbarPresented = true
        var toolbarItems: [ToolbarAction] = [.edit, .copyAndCreateNew]
        if mealItem.type == .product {
            toolbarItems.append(.remove)
        }
        router.presentToolbar(items: toolbarItems) { [weak self] action in
            self?.handle(toolbarAction: action)
        }
    }

    private func configureKeyboardResult(mealItem: MealItem) {
        let serving = mealItem.type == .product || mealItem.ingredients.count <= 1 ? mealItem.mealServing : .serving
        let value = serving.value(with: mealItem.servingMultiplier)
        keyboardResult = .init(displayText: "\(value)",
                               value: value,
                               serving: serving)
    }

    private func presentKeyboard(animation: Animation?) {
        let input = CustomKeyboardInput(
            title: "CustomProductScreen.howMuchToAdd".localized(),
            text: keyboardResult.displayText,
            servings: mealItem.canShowServings ? mealItem.mealServings : [],
            currentServing: serving,
            isPresentedPublisher: Just(true).eraseToAnyPublisher(),
            shouldShowTextField: true,
            isTextSelectedPublisher: Just(!keyboardResult.displayText.isEmpty).eraseToAnyPublisher()
        )
        router.presentKeyboard(input: input, animation: animation) { [weak self] output in
            self?.handle(customKeyboardOutput: output)
        }
    }

    private func closeToolbar() {
        router.dismissBanner()
        isToolbarPresented = false
        presentKeyboard(animation: .linear(duration: 0.15))
    }

    private func handle(customKeyboardOutput output: LogProductKeyboardOutput) {
        switch output {
        case .valueChanged(let result):
            keyboardResult = result
        case .dismissed:
            break
        case .log(let result):
            let mealItem = mealItem.updated(value: result.value, serving: result.serving)
            self.output(.log(mealItem))
        case .add(let result):
            let mealItem = mealItem.updated(value: result.value, serving: result.serving)
            self.output(.add(mealItem))
        }
    }

    private func handle(toolbarAction action: ToolbarAction) {
        closeToolbar()
        switch action {
        case .edit:
            duplicate(context: .edit(mealItem))
        case .copyAndCreateNew:
            duplicate(context: .duplicate(mealItem))
        case .remove:
            delete()
        case .close:
            break
        }
    }

    private func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await mealItemService.delete(byId: mealItem.id)
            try await mealUsageService.delete(byMealItemId: mealItem.id)
            await router.dismiss()
        }
    }

    private func duplicate(context: CustomFoodInput.Context) {
        router.presentCustomFood(context: context) { [weak self] output in
            switch output {
            case .save(let mealItem):
                self?.saveDuplicatedMealItem(mealItem)
            case .edit(let mealItem):
                self?.saveEditedMealItem(mealItem)
            }
            self?.router.dismiss()
        }
    }

    private func saveEditedMealItem(_ mealItem: MealItem) {
        Task {
            let savedMealItem = try await mealItemService.update(mealItem: mealItem)
            await updateMealItem(savedMealItem)
        }
    }

    private func saveDuplicatedMealItem(_ mealItem: MealItem) {
        var mealItem = mealItem
        if mealItem.name.trim == productName.trim {
            mealItem = mealItem.updated(name: productName + " " + "CustomFood.copy".localized())
        }
        saveMealItem(mealItem)
    }

    private func saveMealItem(_ mealItem: MealItem) {
        Task {
            let savedMealItem = try await mealItemService.save(mealItem)
            await updateMealItem(savedMealItem)
        }
    }

    @MainActor
    private func updateMealItem(_ mealItem: MealItem) {
        self.mealItem = mealItem
        configureKeyboardResult(mealItem: mealItem)
        presentKeyboard(animation: nil)
    }
}

private extension MealItem {
    var canShowServings: Bool {
        if mealServings.count < 2 {
            return false
        }
        if ingredients.count <= 1 {
            return true
        }
        return type == .product
    }
}
