//
//  DayFoodViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.04.2024.
//

import Foundation
import AppStudioUI
import Dependencies
import AppStudioServices
import NewAppStudioSubscriptions
import RxSwift
import Combine
import AppStudioModels

class DayFoodViewModel: BaseViewModel<DayFoodOutput> {

    @Dependency(\.userDataService) private var userDataService
    @Dependency(\.mealService) private var mealService
    @Dependency(\.freeUsageService) private var freeUsageService
    @Dependency(\.newSubscriptionService) private var subscriptionService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.rateAppService) private var rateAppService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.intercomService) private var intercomService
    @Dependency(\.requestReviewService) private var requestReviewService
    @Dependency(\.appCustomization) private var appCustomization

    @Published var hasSubscription = false
    @Published var profile: NutritionProfile = .empty
    @Published var mealRecords: [MealTypeRecord] = MealTypeRecord.empty
    let date: Date
    private let router: FoodRouter
    private let disposeBag = DisposeBag()
    private var mealObserver: MealObserver?

    init(input: DayFoodInput, output: @escaping ViewOutput<DayFoodOutput>) {
        self.date = input.date
        self.router = input.router
        super.init(output: output)
        loadProfile()
        observeMeals()
        observeSubscription()
        observeProfileUpdate(publisher: input.updateProfilePublisher)
        observeFoodLogPublisher(publisher: input.foodLogPublisher)
        observeFocusTextPublisher(publisher: input.focusTextFieldPublisher)
        observeProgress()
    }

    var meals: [Meal] {
        mealRecords.flatMap { $0.meals }
    }

    var caloriesLeftValue: CGFloat {
        if profile.calories > 0 {
            return mealRecords.reduce(0) { $0 + $1.calories } / profile.calories
        }
        return 0
    }

    func subscribeTap() {
        presentPaywall(context: .macros)
    }

    func closeBannerTapped() {
        output(.closeBanner)
    }

    func bannerTapped() {
        output(.banner)
    }

    func presentFoodLogScreen(mealType: MealType, context: FoodLogContext) {
        guard hasSubscription || freeUsageService.canAddToDay(date) else {
            presentPaywallAndLogFood(mealType: mealType, context: context)
            return
        }
        output(.switchTabBar(isHidden: true))
        router.dismissBanner()
        let input = foodLogInput(mealType: mealType, context: context)
        router.presentFoodLogScreen(input: input) { [weak self] output in
            guard let self else { return }
            switch output {
            case .closed:
                self.output(.switchTabBar(isHidden: false))
                Task { [weak self] in
                    try await self?.presentRateAppIfNeeded()
                }
            }
        }
    }

    private func presentRateAppIfNeeded() async throws {
        if try await rateAppService.canShowRateAppWindow() {
            try await Task.sleep(seconds: 2)
            await MainActor.run {
                presentRateApp()
            }
            return
        }
        if try await appCustomization.canShowRateUsDialog(), try await rateAppService.canShowRateUsDialog() {
            try await Task.sleep(seconds: 1)
            presentRateUsDialog()
            rateAppService.rateUsDialogShown()
            trackerService.track(.rateUsDialogShown)
            return
        }
        if rateAppService.canShowAppStoreReviewDialog {
            await MainActor.run {
                requestReviewService.requestAppStoreReview()
            }
        }
    }

    @MainActor
    private func presentRateApp() {
        router.presentRateApp { [weak self] output in
            switch output {
            case let .rate(stars, comment):
                self?.trackFeedback(stars: stars, feedback: comment)
            case .close:
                self?.rateAppService.rateAppWindowShown()
            }
        }
    }

    private func presentRateUsDialog() {
        router.presentRateUsDialog { [weak self] output in
            guard let self else { return }
            switch output {
            case .presentSupport:
                self.presentIntercome()
            case .rating(let rating):
                self.trackerService.track(.rateUsDialogAnswered(rate: rating))
                self.rateAppService.userRatedUs()
            case .presentWriteReview:
                break
            }
        }
    }

    private func presentIntercome() {
        intercomService.presentIntercom()
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
    }

    private func foodLogInput(mealType: MealType, context: FoodLogContext) -> FoodLogInput {
        FoodLogInput(
            mealType: mealType,
            dayDate: date,
            context: context,
            initialMeal: mealRecords.first(where: { $0.type == mealType })?.meals ?? [],
            hasSubscription: hasSubscription,
            mealsCountInDay: meals.count
        )
    }

    private func presentPaywallAndLogFood(mealType: MealType, context: FoodLogContext) {
        presentPaywall(context: context == .barcode ? .barcodeScanner : .logLimit) { [weak self] in
            self?.presentFoodLogScreen(mealType: mealType, context: context)
        }
    }

    private func presentPaywall(context: PaywallContext, onSubscribe: (() -> Void)? = nil) {
        router.presentPaywall(context: context) { [weak self] output in
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

    private func onFocusTextField(context: FoodLogContext) {
        let mealType = Date().mealType
        switch context {
        case .input, .view:
            trackerService.track(.tapQuickEntry(container: mealType.rawValue))
        case .barcode:
            trackerService.track(.tapScanBarcode(context: BarcodeScannerOpenContext.quickEntryPanel.rawValue))
        }
        presentFoodLogScreen(mealType: mealType, context: context)
    }

    private func loadProfile() {
        Task { [weak self] in
            guard let self else { return }
            let profile = try await userDataService.nutritionProfile(dayDate: date)
            await MainActor.run {
                self.profile = profile
            }
        }
    }

    private func observeMeals() {
        mealObserver = mealService.mealObserver(dayDate: date)
        mealObserver?.results
            .map(with: self) { this, meals in
                this.groupMeals(meals)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$mealRecords)
    }

    private func groupMeals(_ meals: [Meal]) -> [MealTypeRecord] {
        var groupedMeals: [MealType: [Meal]] = [:]
        for meal in meals {
            groupedMeals[meal.type, default: []].append(meal)
        }
        return [.init(type: .breakfast, meals: groupedMeals[.breakfast] ?? []),
                .init(type: .lunch, meals: groupedMeals[.lunch] ?? []),
                .init(type: .dinner, meals: groupedMeals[.dinner] ?? []),
                .init(type: .snack, meals: groupedMeals[.snack] ?? [])]
    }

    private func observeSubscription() {
        subscriptionService.hasSubscription
            .removeDuplicates()
            .assign(to: &$hasSubscription)
    }

    private func observeProfileUpdate(publisher: AnyPublisher<Void, Never>) {
        publisher.sink { [weak self] _ in
            self?.loadProfile()
        }
        .store(in: &cancellables)
    }

    private func observeFoodLogPublisher(publisher: AnyPublisher<(Date, MealType), Never>) {
        publisher
            .filter { [weak self] in $0.0 == self?.date }
            .map { $0.1 }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, type in
                this.trackTapAddFood(type: type, context: .plusMenu)
                this.presentFoodLogScreen(mealType: type, context: .input)
            }
            .store(in: &cancellables)
    }

    private func observeFocusTextPublisher(publisher: AnyPublisher<(Date, FoodLogContext), Never>) {
        publisher
            .filter { [weak self] in $0.0 == self?.date }
            .map { $0.1 }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, context in
                this.onFocusTextField(context: context)
            }
            .store(in: &cancellables)
    }

    private func observeProgress() {
        Publishers.CombineLatest($profile, $mealRecords)
            .dropFirst()
            .map {
                DayProgress(goal: $0.0.calories, result: $0.1.reduce(0) { $0 + $1.calories })
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] progress in
                guard let self else { return }
                self.output(.dayProgress(date: self.date, progress: progress))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Analytics
extension DayFoodViewModel {
    func trackTapOpenContainer(type: MealType) {
        trackerService.track(.tapOpenContainer(container: type.rawValue))
    }

    func trackTapAddFood(type: MealType, context: ContainerOpenContext) {
        trackerService.track(.tapAddToContainer(container: type.rawValue, context: context.rawValue))
    }

    func trackFeedback(stars: Int, feedback: String) {
        trackerService.track(.feedbackSent(rating: "\(stars)", feedback: feedback))
        userPropertyService.set(userProperties: ["feedback_rating" : feedback])
    }
}

private extension Date {
    var mealType: MealType {
        switch hour {
        case 0 ... 2: .dinner
        case 3 ... 11: .breakfast
        case 12 ... 15: .lunch
        case 16 ... 24: .dinner
        default: .dinner
        }
    }
}
