//
//  FoodLogInputViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.06.2024.
//

import Foundation
import AppStudioUI
import Combine

struct FoodLogInputViewInput {
    let mealType: MealType
    let dayDate: Date
    let isKeyboardFocused: Bool
    let hasSubscription: Bool
    let shouldPresentScannerOnAppear: Bool
    let mealPublisher: AnyPublisher<[MealItem], Never>
    let editQuickAddPublisher: AnyPublisher<Meal, Never>
}

enum FoodLogInputOutput {
    case insert(Meal)
    case update(Meal)
    case save(meals: [Meal], placeholderId: String)
    case remove(MealItem)
    case appendPlaceholder(MealPlaceholder)
    case dismiss
    case notFoundBarcode(String)
    case hasSubscription(Bool)
    case onFocus
}

class FoodLogInputViewModel: BaseViewModel<FoodLogInputOutput> {

    @Published var logType: LogType = .log
    @Published var quickAddMeal: Meal?
    @Published var suggestionsState: SuggestionsState

    let router: FoodLogRouter
    let input: FoodLogInputViewInput
    private let presentScannerPublisher = PassthroughSubject<Void, Never>()

    init(router: FoodLogRouter,
         input: FoodLogInputViewInput,
         output: @escaping ViewOutput<FoodLogInputOutput>) {
        self.router = router
        self.input = input
        suggestionsState = .init(isPresented: input.isKeyboardFocused,
                                 isKeyboardFocused: input.isKeyboardFocused)
        super.init(output: output)
        observeEditQuickAdd(publisher: input.editQuickAddPublisher)
    }

    var historyViewModel: FoodHistoryViewModel {
        .init(
            input: .init(
                mealType: input.mealType,
                dayDate: input.dayDate,
                suggestionsState: logType == .history ?
                    .init(isPresented: true, isKeyboardFocused: true) :
                    suggestionsState,
                hasSubscription: input.hasSubscription,
                presentScannerPublusher: presentScannerPublisher.eraseToAnyPublisher(),
                mealPublisher: input.mealPublisher
            ),
            router: router) { [weak self] output in
                self?.handle(foodHistoryOutput: output)
            }
    }

    var quickAddViewModel: QuickAddViewModel {
        .init(input: .init(
            meal: quickAddMeal,
            mealType: input.mealType,
            dayDate: input.dayDate)
        ) { [weak self] output in
            self?.handle(quickAddOutput: output)
        }
    }

    func onAppear() {
        if input.shouldPresentScannerOnAppear {
            presentScannerPublisher.send()
        }
    }

    func changeLogType(to type: LogType) {
        logType = type
    }

    private func handle(quickAddOutput: QuickAddOutput) {
        switch quickAddOutput {
        case .created(let meal):
            output(.insert(meal))
        case .updated(let meal):
            output(.update(meal))
        case .logType(let type):
            suggestionsState = .init(isPresented: false, isKeyboardFocused: true)
            quickAddMeal = nil
            changeLogType(to: type)
        case .close:
            suggestionsState = .init(isPresented: true, isKeyboardFocused: true)
            quickAddMeal = nil
            changeLogType(to: .log)
        }
    }

    private func handle(foodHistoryOutput output: FoodHistoryOutput) {
        switch output {
        case .insert(let meal):
            self.output(.insert(meal))
        case .save(let meals, let placeholderId):
            self.output(.save(meals: meals, placeholderId: placeholderId))
        case .remove(let mealItem):
            self.output(.remove(mealItem))
        case .appendPlaceholder(let mealPlaceholder):
            self.output(.appendPlaceholder(mealPlaceholder))
        case .dismiss:
            self.output(.dismiss)
        case .notFoundBarcode(let placeholderId):
            self.output(.notFoundBarcode(placeholderId))
        case .hasSubscription(let hasSubscription):
            self.output(.hasSubscription(hasSubscription))
        case let .logType(type, isFocused):
            suggestionsState = .init(isPresented: isFocused, isKeyboardFocused: isFocused)
//            isHistoryKeyboardFocused = isFocused
            changeLogType(to: type)
        case .onFocus:
            self.output(.onFocus)
        }
    }

    private func observeEditQuickAdd(publisher: AnyPublisher<Meal, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, meal in
                this.quickAddMeal = meal
                this.changeLogType(to: .quickAdd)
            }
            .store(in: &cancellables)
    }
}
