//
//  FoodLogInputViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 05.06.2024.
//

import Foundation
import AppStudioUI
import Combine
import Dependencies

struct SuggestionsState: Equatable {
    let isPresented: Bool
    let isKeyboardFocused: Bool
}

class FoodHistoryViewModel: BaseViewModel<FoodHistoryOutput> {

    @Dependency(\.mealService) private var mealService
    @Dependency(\.freeUsageService) private var freeUsageService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.calorieCounterService) private var calorieCounterService
    @Dependency(\.foodSearchService) private var foodSearchService
    @Dependency(\.cameraAccessService) private var cameraAccessService
    @Published var hasMeals: Bool = false
    @Published var mealRequest = ""
    @Published var hasSubscription: Bool
    private var dismissSuggestionsSubject = PassthroughSubject<Void, Never>()
    private var isBarcodeScanFinishedSuccess = false
    @Published var suggestionsState: SuggestionsState
    private let router: FoodLogRouter

    let input: FoodHistoryInput

    init(input: FoodHistoryInput, router: FoodLogRouter, output: @escaping ViewOutput<FoodHistoryOutput>) {
        self.input = input
        suggestionsState = input.suggestionsState
        self.router = router
        hasSubscription = input.hasSubscription
        super.init(output: output)
        observeMealPublisher(publisher: input.mealPublisher)
        observeScannerPublisher(publisher: input.presentScannerPublusher)
        observeSuggestionsState()
    }

    func changeLogType(to type: LogType, isFocused: Bool) {
        output(.logType(type: type, isFocused: isFocused))
    }

    func dismiss() {
        output(.dismiss)
    }

    func closeSuggestions() {
        dismissSuggestionsSubject.send()
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

    private func observeMealPublisher(publisher: AnyPublisher<[MealItem], Never>) {
        publisher
            .map { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasMeals)
    }

    private func observeScannerPublisher(publisher: AnyPublisher<Void, Never>) {
        publisher
            .sink(with: self) { this, _ in
                Task { [weak this] in
                    guard let this else { return }
                    let cameraAccessGranted = await this.cameraAccessService.requestAccess()
                    await MainActor.run {
                        this.barcodeScan(accessGranted: cameraAccessGranted)
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func observeSuggestionsState() {
        $suggestionsState
            .filter { $0.isKeyboardFocused }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.output(.onFocus)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Suggestions
extension FoodHistoryViewModel {
    var foodSuggestionsInput: FoodSuggestionsInput {
        .init(mealPublisher: input.mealPublisher,
              mealType: input.mealType,
              mealRequestPublisher: $mealRequest.eraseToAnyPublisher(),
              isPresented: input.suggestionsState.isPresented,
              collapsePublisher: dismissSuggestionsSubject.eraseToAnyPublisher(),
              searchRequest: mealRequest)
    }

    func handle(foodSuggestionsOutput output: FoodSuggestionsOutput) {
        switch output {
        case .add(let mealItem):
            let meal = Meal(type: input.mealType,
                            dayDate: input.dayDate,
                            mealItem: mealItem,
                            voting: .disabled)
            mealRequest = ""
            self.output(.insert(meal))
        case .remove(let mealItem):
            self.output(.remove(mealItem))
        case .togglePresented(let isPresented):
            suggestionsState = .init(isPresented: isPresented, isKeyboardFocused: isPresented)
        }
    }
}

// MARK: - Log Meal
extension FoodHistoryViewModel {
    func logMeal(text: String) {
        Task { [weak self] in
            guard let self else { return }
            try await requestMeal(text: text)
        }
    }

    private func requestMeal(text: String) async throws {
        let placeholder = MealPlaceholder(mealText: text)
        await appendPlaceholder(placeholder)
        trackerService.track(.entrySent)
        let meals = try await meals(request: text, type: input.mealType)
        trackerService.track(.mealAdded(ingredientsCounts: meals.flatMap { $0.mealItem.ingredients }.count))
        output(.save(meals: meals, placeholderId: placeholder.id))
    }

    private func meals(request: String, type: MealType) async throws -> [Meal] {
        let mealItems = try await calorieCounterService.food(request: request)
        return mealItems.map { Meal(type: type, dayDate: input.dayDate, mealItem: $0, voting: .notVoted) }
    }
}

// MARK: - Barcode
extension FoodHistoryViewModel {

    func barcodeScan(accessGranted: Bool) {
        guard accessGranted else {
            router.presentCameraAccessAlert()
            return
        }
        isBarcodeScanFinishedSuccess = true
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
            logMeal(barcode: barcode)
            isBarcodeScanFinishedSuccess = true
        case .close:
            if !isBarcodeScanFinishedSuccess {
                dismiss()
            }
        }
    }

    func logMeal(barcode: String) {
        Task {
            try await searchMeal(barcode: barcode)
        }
    }

    private func searchMeal(barcode: String) async throws {
        let placeholder = MealPlaceholder(mealText: barcode)
        await appendPlaceholder(placeholder)

        guard let mealItem = try await foodSearchService.search(barcode: barcode) else {
            trackBarcodeScanned(isSucces: false, productName: nil)
            output(.notFoundBarcode(placeholder.id))
            return
        }
        let meals = [Meal(type: input.mealType, dayDate: input.dayDate, mealItem: mealItem, voting: .disabled)]
        trackBarcodeScanned(isSucces: true, productName: mealItem.name)
        output(.save(meals: meals, placeholderId: placeholder.id))
    }

    @MainActor
    private func appendPlaceholder(_ placeholder: MealPlaceholder) {
        dismissSuggestionsSubject.send()
        suggestionsState = .init(isPresented: false, isKeyboardFocused: true)
        output(.appendPlaceholder(placeholder))
    }
}

// MARK: - Analytics
extension FoodHistoryViewModel {
    func trackBarcodeScannerOpen() {
        trackerService.track(.tapScanBarcode(context: BarcodeScannerOpenContext.container.rawValue))
    }

    func trackTapFinishLogging() {
        trackerService.track(.tapFinishLogging)
    }

    private func trackBarcodeScanned(isSucces: Bool, productName: String?) {
        trackerService.track(.barcodeScanned(result: isSucces ? "success" : "fail",
                                             productName: productName))
    }
}