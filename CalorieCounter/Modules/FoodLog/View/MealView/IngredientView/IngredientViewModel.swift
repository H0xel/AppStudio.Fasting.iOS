//
//  IngredientViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 31.05.2024.
//

import Foundation
import AppStudioUI
import Dependencies
import Combine

struct IngredientViewInput {
    let ingredient: Ingredient
    let router: IngredientRouter
    let statePublisher: AnyPublisher<Ingredient?, Never>
    let tappedWeightIngredientPublisher: AnyPublisher<Ingredient, Never>
}

enum IngredientOutput {
    case ingredientTapped(Ingredient)
    case weightTapped(Ingredient)
    case deleted(Ingredient)
    case updated(newIngredient: Ingredient, oldIngredient: Ingredient)
    case direction(CustomKeyboardDirection)
    case notSelected
}

enum IngredientViewState {
    case notSelected
    case tapped
    case weightTapped
}

class IngredientViewModel: BaseViewModel<IngredientOutput> {

    @Dependency(\.trackerService) private var trackerService
    @Published var state: IngredientViewState = .notSelected
    @Published var isWeightTextSelected = false
    @Published private var editingResult: CustomKeyboardResult?

    let ingredient: Ingredient
    private let router: IngredientRouter

    init(input: IngredientViewInput, output: @escaping ViewOutput<IngredientOutput>) {
        self.router = input.router
        self.ingredient = input.ingredient
        super.init(output: output)
        observeStateChange(publisher: input.statePublisher)
        observeTappedWeightPublisher(publisher: input.tappedWeightIngredientPublisher)
    }

    var isTapped: Bool {
        state == .tapped
    }

    var isWeightTapped: Bool {
        state == .weightTapped
    }

    var displayWeight: String {
        editingResult?.displayText ?? ingredient.weight.withoutDecimalsIfNeeded
    }

    var displayServing: MealServing {
        editingResult?.serving ?? ingredient.serving
    }

    func weightTapped() {
        trackerService.track(.tapChangeWeight(context: .ingredient))
        if case .weightTapped = state {
            clearSelection()
            return
        }
        state = .weightTapped
        output(.weightTapped(ingredient))
        presentWeightChangeBanner()
    }

    func ingredientTapped() {
        trackerService.track(.elementChosen(context: .ingredient))
        if case .tapped = state {
            clearSelection()
            return
        }
        state = .tapped
        output(.ingredientTapped(ingredient))
        presentIngredientDeleteBanner(ingredient: ingredient)
    }

    private func observeStateChange(publisher: AnyPublisher<Ingredient?, Never>) {
        publisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, ingredient in
                if ingredient?.name != this.ingredient.name {
                    this.state = .notSelected
                    this.isWeightTextSelected = false
                }
            }
            .store(in: &cancellables)
    }

    private func observeTappedWeightPublisher(publisher: AnyPublisher<Ingredient, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, ingredient in
                if this.ingredient == ingredient {
                    this.weightTapped()
                    this.isWeightTextSelected = true
                }
            }
            .store(in: &cancellables)
    }

    private func changeIngredientWeight(result: CustomKeyboardResult) {
        guard Int(ingredient.weight) != Int(result.value) else {
            return
        }
        let changedIngredient = ingredient.updated(value: result.value, serving: result.serving)
        output(.updated(newIngredient: changedIngredient, oldIngredient: ingredient))
        trackWeightChanged(newWeight: result.value)
    }

    private func presentIngredientDeleteBanner(ingredient: Ingredient) {
        router.presentDeleteBanner(editType: .deleteIngredient) { [weak self] in
            self?.clearSelection()
        } onDelete: { [weak self] in
            guard let self else { return }
            trackerService.track(.elementDeleted(context: .ingredient))
            output(.deleted(ingredient))
            clearSelection()
        } onEdit: {}
    }

    private func presentWeightChangeBanner() {
        let input = CustomKeyboardInput(
            title: ingredient.name,
            text: "\(ingredient.weight)",
            servings: ingredient.servings,
            currentServing: ingredient.serving,
            isPresentedPublisher: $state.map { $0 != .notSelected }.eraseToAnyPublisher(),
            shouldShowTextField: false, 
            isTextSelectedPublisher: $isWeightTextSelected.eraseToAnyPublisher())
        router.presentChangeWeightBanner(input: input) { [weak self] output in
            self?.handle(customKeyboardOutput: output)
        }
    }

    private func handle(customKeyboardOutput output: ContainerKeyboardOutput) {
        switch output {
        case .valueChanged(let result):
            editingResult = result
        case .add(let result):
            changeIngredientWeight(result: result)
            clearSelection()
            editingResult = nil
        case .dismissed(let result):
            changeIngredientWeight(result: result)
            editingResult = nil
        case .direction(let direction):
            self.output(.direction(direction))
        }
    }

    private func clearSelection() {
        state = .notSelected
        output(.notSelected)
    }

    private func trackWeightChanged(newWeight: CGFloat) {
        trackerService.track(.weightChanged(currentWeight: newWeight,
                                            previousWeight: ingredient.weight,
                                            context: .ingredient))
    }
}
