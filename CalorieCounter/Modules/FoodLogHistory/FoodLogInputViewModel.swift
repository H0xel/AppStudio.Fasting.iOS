//
//  FoodLogInputViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.06.2024.
//

import Foundation
import AppStudioUI
import Combine
import Dependencies

struct FoodLogInputViewInput {
    let mealTypePublisher: AnyPublisher<MealType, Never>
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
    case notFoundAISearch(String)
    case hasSubscription(Bool)
    case onFocus
}

class FoodLogInputViewModel: BaseViewModel<FoodLogInputOutput> {

    @Dependency(\.mealItemService) private var mealItemService

    @Published var logType: LogType = .log
    @Published var quickAddMeal: Meal?
    @Published var suggestionsState: SuggestionsState
    @Published var mealType: MealType = .breakfast

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
        input.mealTypePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$mealType)
    }

    var historyViewModel: FoodHistoryViewModel {
        .init(
            input: .init(
                mealTypePublusher: $mealType.eraseToAnyPublisher(),
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
            mealType: mealType,
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
            quickAddMeal = nil
            changeLogType(to: type, isFocused: true)
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
            changeLogType(to: type, isFocused: isFocused)
        case .onFocus:
            self.output(.onFocus)
        case .present(let mealItem):
            presentProduct(mealItem: mealItem)
        case .notFoundAISearch(let placeholderId):
            self.output(.notFoundAISearch(placeholderId))
        }
    }

    private func changeLogType(to type: LogType, isFocused: Bool) {
        suggestionsState = .init(isPresented: isFocused, isKeyboardFocused: isFocused)
        if type == .newFood {
            changeLogType(to: .log)
            presentCustomFood()
            return
        }
        changeLogType(to: type)
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

    private func presentCustomFood() {
        router.presentCustomFood(context: .create) { [weak self] mealItem in
            guard let self else { return }
            Task { [weak self] in
                guard let self else { return }
                let savedMealItem = try await self.mealItemService.save(mealItem)
                presentProduct(mealItem: savedMealItem)
            }
        }
    }

    private func presentProduct(mealItem: MealItem) {
        router.presentCustomProduct(mealItem: mealItem) { [weak self] output in
            self?.handle(customProductOutput: output)
        }
    }

    private func handle(customProductOutput output: CustomProductOutput) {
        switch output {
        case .add(let mealItem):
            insertMeal(mealItem)
            router.dismiss()
        case .log(let mealItem):
            insertMeal(mealItem)
            router.dismiss(FoodLogRoute.self)
        }
    }

    private func insertMeal(_ mealItem: MealItem) {
        let meal = Meal(type: mealType,
                        dayDate: input.dayDate,
                        mealItem: mealItem,
                        voting: .disabled)
        self.output(.insert(meal))
    }
}
