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
}

enum IngredientOutput {
    case ingredientTapped(Ingredient)
    case weightTapped(Ingredient)
    case deleted(Ingredient)
    case updated(newIngredient: Ingredient, oldIngredient: Ingredient)
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

    let ingredient: Ingredient
    private let router: IngredientRouter

    init(input: IngredientViewInput, output: @escaping ViewOutput<IngredientOutput>) {
        self.router = input.router
        self.ingredient = input.ingredient
        super.init(output: output)
        observeStateChange(publisher: input.statePublisher)
    }

    var isTapped: Bool {
        state == .tapped
    }

    var isWeightTapped: Bool {
        state == .weightTapped
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
                if ingredient != this.ingredient {
                    this.state = .notSelected
                }
            }
            .store(in: &cancellables)
    }

    private func changeIngredientWeight(to newWeight: Double) {
        guard Int(ingredient.weight) != Int(newWeight) else {
            return
        }
        let changedIngredient = ingredient.updated(newWeight: newWeight)
        output(.updated(newIngredient: changedIngredient, oldIngredient: ingredient))
        trackWeightChanged(newWeight: newWeight)
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
        router.presentChangeWeightBanner(title: ingredient.name,
                                         initialWeight: ingredient.weight) { [weak self] weight in
            self?.changeIngredientWeight(to: weight)
            self?.clearSelection()
        } onCancel: { [weak self] in
            self?.clearSelection()
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
