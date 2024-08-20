//  
//  CustomFoodViewModel.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies
import AppStudioStyles

class CustomFoodViewModel: BaseViewModel<CustomFoodOutput> {
    @Dependency(\.cameraAccessService) private var cameraAccessService
    @Dependency(\.mealItemService) private var mealItemService

    let router: CustomFoodRouter

    @Published var isKeyboardPresented = false
    @Published var selectedField: CustomFoodField = .none
    @Published var customFoodViewData: CustomFoodViewData
    @Published var isInputTextSelected = false
    @Published private var amountPerFieldWasFocused: Double = 0
    @Published private var servingSizeFieldWasFocused: Double = 0
    @Published private(set) var changedFields: Set<CustomFoodField> = []

    private let customFoodViewDataCopy: CustomFoodViewData

    private var hasNoUpdates: Bool {
        customFoodViewData == customFoodViewDataCopy
    }

    var title: LocalizedStringKey {
        "CustomFood.amountPer \("\(customFoodViewData.servingSize.withoutDecimalsIfNeeded) \(customFoodViewData.selectedServing.measure)")"
    }

    var normalizedProfile: NutritionProfile {
        let profile = NutritionProfile(
            calories: customFoodViewData.calories,
            proteins: customFoodViewData.protein,
            fats: customFoodViewData.fat,
            carbohydrates: customFoodViewData.carbs
        )

        return profile.normalize(with: customFoodViewData.servingSize, amountPer: customFoodViewData.amountPer)
    }

    var canShowBudgetView: Bool {
        customFoodViewData.carbs != 0
        || customFoodViewData.fat != 0
        || customFoodViewData.protein != 0
    }

    private let context: CustomFoodInput.Context

    init(router: CustomFoodRouter, input: CustomFoodInput, output: @escaping CustomFoodOutputBlock) {
        self.router = router
        context = input.context
        switch input.context {
        case .create:
            customFoodViewData = .initial()
            customFoodViewDataCopy = .initial()
        case .edit(let mealItem):
            customFoodViewData = .duplicate(mealItem: mealItem)
            customFoodViewDataCopy = .duplicate(mealItem: mealItem)
        case .barcode(let barcode):
            customFoodViewData = .initial(barcode: barcode)
            customFoodViewDataCopy = .initial(barcode: barcode)
        case .duplicate(let mealItem):
            let mealItem = mealItem.updated(
                id: UUID().uuidString,
                name: mealItem.name  + " " + "CustomFood.copy".localized()
            )
            customFoodViewData = .duplicate(mealItem: mealItem)
            customFoodViewDataCopy = .duplicate(mealItem: mealItem)
        }
        super.init(output: output)
        subscribeToTextFieldChange()
        fillChangedFieldsIfNeeded()
    }

    func save() {
        switch context {
        case .create, .barcode:
            let mealItem = MealItem(viewData: customFoodViewData)
            output(.save(mealItem))
        case .edit(let mealItem):
            let mealItem = mealItem.duplicate(viewData: customFoodViewData)
            output(.edit(mealItem))
        case .duplicate(let mealItem):
            let mealItem = mealItem.duplicate(viewData: customFoodViewData)
            output(.save(mealItem))
        }
    }

    func dismiss() {
        if hasNoUpdates  {
            router.dismiss()
            return
        }
        router.presentBottomSheet(configuration: .discardChanges) { [weak self] in
            self?.router.dismiss()
        }
    }

    func handle(_ action: CustomFoodBarCodeView.Action) {
        switch action {
        case .openBarcodeScanner, .replace:
            presentBarcodeScanner()
        case .delete:
            router.presentBottomSheet(configuration: .deleteBarcode) { [weak self] in
                self?.customFoodViewData.barcode = nil
                self?.router.dismiss()
            }
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.isKeyboardPresented = false
        }

        if selectedField == .servingSize || selectedField == .amountPer {
            amountPerFieldWasFocused = customFoodViewData.amountPer
            servingSizeFieldWasFocused = customFoodViewData.servingSize
        }

        if selectedField != .brandName || selectedField != .foodName {
            selectedField = .none
        }
        router.dismissBanner(animation: .linear(duration: 0.5))
    }

    private func subscribeToTextFieldChange() {
        $selectedField
            .sink(with: self) { this, selectedField in
                switch selectedField.keyboardType {
                case .none: break
                case .text:
                    this.clear()
                case .customNumpad:
                    this.presentWeightChangeBanner(selectedField: selectedField)
                    this.isInputTextSelected = true
                case .customText:
                    this.presentTextChangeBanner(selectedField: selectedField)
                }
            }
            .store(in: &cancellables)
    }

    private func handle(customKeyboardOutput output: ContainerKeyboardOutput) {
        switch output {
        case .valueChanged(let result):
            keyboardValueChanged(result: result)
            isInputTextSelected = false
        case .servingChanged(let result):
            keyboardValueChanged(result: result)
            isInputTextSelected = true
        case .add, .dismissed:
            clear()
        case .direction(let direction):
            keyboardDirectionChanged(direction: direction)
        }
    }

    private func keyboardDirectionChanged(direction: CustomKeyboardDirection) {
        switch direction {
        case .up:
            if selectedField.previous() != .none {
                selectedField = selectedField.previous()
            }
        case .down:
            if selectedField.next() != .none {
                selectedField = selectedField.next()
            }
        }
    }

    private func keyboardValueChanged(result: CustomKeyboardResult) {
        if selectedField == .amountPer || selectedField == .servingSize {
            customFoodViewData.selectedServing = result.serving
        }
        setKeyboardValueToCustomField(selectedField, keyboardResult: result)
    }

    private func setKeyboardValueToCustomField(_ selectedField: CustomFoodField, keyboardResult: CustomKeyboardResult) {
        switch selectedField {
        case .none, .brandName, .foodName, .servingName: break
        case .servingSize:
            customFoodViewData.servingSize = keyboardResult.value
        case .servingAmount:
            customFoodViewData.servingAmount = keyboardResult.value
        case .amountPer:
            customFoodViewData.amountPer = keyboardResult.value
        case .calories:
            customFoodViewData.calories = keyboardResult.value
        case .fat:
            customFoodViewData.fat = keyboardResult.value
        case .carbs:
            customFoodViewData.carbs = keyboardResult.value
        case .protein:
            customFoodViewData.protein = keyboardResult.value
        }
        changedFields.insert(selectedField)
    }

    func customFoodFieldToKeyboardText(_ selectedField: CustomFoodField) -> String {
        switch selectedField {
        case .none, .brandName, .foodName: return ""
        case .servingSize: return String(describing: customFoodViewData.servingSize)
        case .servingAmount: return "\(customFoodViewData.servingAmount)"
        case .servingName: return customFoodViewData.servingName
        case .amountPer: return String(describing: customFoodViewData.amountPer)
        case .calories: return String(describing: customFoodViewData.calories)
        case .fat: return String(describing: customFoodViewData.fat)
        case .carbs: return String(describing: customFoodViewData.carbs)
        case .protein: return String(describing: customFoodViewData.protein)
        }
    }

    func getServing(_ selectedField: CustomFoodField) -> MealServing {
        switch selectedField {
        case .servingName, .servingAmount:
            return .init(weight: nil, measure: "", quantity: 1)
        case .amountPer, .servingSize:
            return customFoodViewData.selectedServing
        case .calories:
            return .init(weight: nil, measure: "kcal", quantity: 1)
        case .fat, .carbs, .protein, .none, .foodName, .brandName:
            return .defaultServing
        }
    }

    private func fillChangedFieldsIfNeeded() {
        guard !context.isInitial else { return }
        var fields: [CustomFoodField] = [.servingSize, .servingAmount, .calories, .fat, .carbs, .protein, .servingName]
        if customFoodViewData.amountPer > 0 {
            fields.append(.amountPer)
        }
        changedFields = Set(fields)
    }
}

// MARK: Routing

private extension CustomFoodViewModel {
    func presentTextChangeBanner(selectedField: CustomFoodField) {
        DispatchQueue.main.async {
            self.isKeyboardPresented = true
        }

        let input = CustomTextKeyboardInput(
            title: selectedField.keyboardTitle,
            text: customFoodFieldToKeyboardText(selectedField)
        )

        router.presentChangeTextBanner(input: input) { [weak self] output in
            switch output {
            case .nextButtonTapped:
                self?.handle(customKeyboardOutput: .direction(.down))
            case let .textChanged(text):
                DispatchQueue.main.async {
                    self?.customFoodViewData.servingName = text
                    if text != CustomFoodViewData.initial().servingName {
                        self?.changedFields.insert(.servingName)
                    }
                }
            }
        }
    }

    func presentWeightChangeBanner(selectedField: CustomFoodField) {
        DispatchQueue.main.async {
            self.isKeyboardPresented = true
        }
        let input = CustomKeyboardInput(
            title: selectedField.keyboardTitle,
            text: customFoodFieldToKeyboardText(selectedField),
            servings: selectedField.canShowServings ? customFoodViewData.servings : [],
            currentServing: getServing(selectedField),
            isPresentedPublisher: $isKeyboardPresented.eraseToAnyPublisher(),
            shouldShowTextField: false,
            isTextSelectedPublisher: $isInputTextSelected.eraseToAnyPublisher()
        )

        router.presentChangeWeightBanner(input: input) { [weak self] output in
            self?.handle(customKeyboardOutput: output)
        }
    }

    func presentBarcodeScanner() {
        router.presentBarcodeScanner { [weak self] output in
            switch output {
            case let .barcode(barcode):
                self?.customFoodViewData.barcode = barcode
                self?.router.dismiss()
            case .close:
                self?.router.dismiss()
            }
        }
    }
}
