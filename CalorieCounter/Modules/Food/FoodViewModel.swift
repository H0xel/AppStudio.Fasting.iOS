//  
//  FoodViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies
import Combine
import RxSwift

class FoodViewModel: BaseViewModel<FoodOutput> {
    var router: FoodRouter!
    @Published var currentDay: Date
    @Published var currentWeek: Week
    @Published var mealRecords: [Date: [MealTypeRecord]] = [:]
    @Published var hasSubscription = false
    @Published var tabViewId = UUID()
    @Published var discountPaywallInfo: DiscountPaywallInfo?
    @Published var timerInterval: TimeInterval = .second
    @Published private var profiles: [Date: NutritionProfile] = [:]
    @Published private var days: Set<Date> = []
    @Published private var weeks: Set<Week> = []
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var mealObserver: MealObserver?
    private var mealCancellable: AnyCancellable?
    private let disposeBag = DisposeBag()

    @Dependency(\.mealService) private var mealService
    @Dependency(\.userDataService) private var userDataService
    @Dependency(\.subscriptionServiceAdapter) private var subscriptionService
    @Dependency(\.freeUsageService) private var freeUsageService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService

    init(input: FoodInput, output: @escaping FoodOutputBlock) {
        currentDay = .now.beginningOfDay
        let currentWeek = Date().daysOfWeek
        self.currentWeek = .init(days: currentWeek)
        days = Set(currentWeek)
        weeks = [Week(days: currentWeek)]
        super.init(output: output)
        observeCurrentDateChange()
        observeCurrentWeekChange()
        observeFoodLogPublisher(publisher: input.presentFoodLogPublisher)
        observeProfileUpdatePublisher(publisher: input.profileUpdatePublisher)
        observeSubscription()
        initializeDiscountPaywallExperiment()
        subscribeForAvailableDiscountPaywall()
    }

    func calorieBudget(for day: Date) -> NutritionProfile {
        profiles[day] ?? .empty
    }

    func weekProgress(week: Week) -> [FoodCalendarDayProgress] {
        week.days
            .map { ($0, mealRecords[$0] ?? []) }
            .map {
                .init(day: $0.0,
                      goal: calorieBudget(for: $0.0).calories,
                      result: $0.1.reduce(0) { $0 + $1.calories })
            }
    }

    var displayWeeks: [Week] {
        weeks.sorted(by: <)
    }

    var displayDays: [Date] {
        days.sorted(by: <)
    }

    func records(for day: Date) -> [MealTypeRecord] {
        mealRecords[day] ?? []
    }

    func meals(for day: Date) -> [Meal] {
        records(for: day).flatMap { $0.meals }
    }

    func caloriesLeftValue(for day: Date) -> CGFloat {
        records(for: day).reduce(0) { $0 + $1.calories } / calorieBudget(for: day).calories
    }

    func selectDate(_ date: Date) {
        trackerService.track(.tapDate(date: date.description))
        guard date != currentDay else { return }
        currentDay = date
        updateTabViewId()
    }

    func addMeal(type: MealType, context: FoodLogContext) {
        presentFoodLogScreen(mealType: type, context: context)
    }

    func presentTextField(isFocused: Bool) {
        router.presentTextField { [weak self] in
            self?.onFocusTextField(context: .input)
        } onBarcodeScan: { [weak self] in
            self?.onFocusTextField(context: .barcode)
        }
    }

    func subscribeTap() {
        presentPaywall(context: .macros)
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

    private func observeCurrentDateChange() {
        $currentDay
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, date in
                this.configureObserver(for: date)
                this.updateProfile(date: date)
                if !this.currentWeek.days.contains(date) {
                    this.currentWeek = .init(days: date.daysOfWeek)
                }
            }
            .store(in: &cancellables)
    }

    private func updateProfile(date: Date) {
        Task { [weak self] in
            guard let self else { return }
            let profile = try await self.userDataService.nutritionProfile(dayDate: date)
            await MainActor.run {
                self.profiles[date] = profile
            }
        }
    }

    private func configureObserver(for date: Date) {
        mealObserver = mealService.mealObserver(dayDate: date)

        mealCancellable = mealObserver?.results
            .dropFirst()
            .map(with: self) { this, meals in
                this.groupMeals(meals)
            }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, meals in
                this.mealRecords[date] = meals
            }
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

    private func observeCurrentWeekChange() {
        $currentWeek
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, week in
                let weeks: [Week] = [week.previous, week, week.next]
                this.loadMeals(for: weeks)
                this.insertDays(of: weeks)
                this.updateTabViewId()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    this.insertWeeks(weeks)
                }
            }
            .store(in: &cancellables)

        $currentWeek
            .dropFirst()
            .sink(with: self) { this, week in
                let direction: SwipeDirection = week > this.currentWeek ? .forward : .backward
                this.trackerService.track(.swipeWeek(direction: direction.rawValue))
            }
            .store(in: &cancellables)
    }

    private func loadMeals(for weeks: [Week]) {
        Task { [weak self] in
            guard let self else { return }
            for day in weeks.flatMap({ $0.days }) where self.mealRecords[day] == nil {
                let meals = try await self.mealService.meals(forDay: day, type: nil)
                let grouppedMeals = self.groupMeals(meals)
                await setRecords(grouppedMeals, date: day)
                let profile = try await userDataService.nutritionProfile(dayDate: day)
                await setProfile(profile, date: day)
                await Task.yield()
            }
        }
    }

    @MainActor
    private func setProfile(_ profile: NutritionProfile, date: Date) {
        profiles[date] = profile
    }

    @MainActor
    private func setRecords(_ records: [MealTypeRecord], date: Date) {
        mealRecords[date] = records
    }

    private func insertDays(of weeks: [Week]) {
        var newDays = days
        weeks.flatMap { $0.days }.forEach { day in
            newDays.insert(day)
        }
        days = newDays
    }

    private func insertWeeks(_ weeks: [Week]) {
        var newWeeks = self.weeks
        for week in weeks {
            newWeeks.insert(week)
        }
        self.weeks = newWeeks
    }

    private func onFocusTextField(context: FoodLogContext) {
        let now = Date()
        let mealType: MealType =
        switch now.hour {
        case 0 ... 2: .dinner
        case 3 ... 11: .breakfast
        case 12 ... 15: .lunch
        case 16 ... 24: .dinner
        default: .dinner
        }
        switch context {
        case .input, .view:
            trackerService.track(.tapQuickEntry(container: mealType.rawValue))
        case .barcode:
            trackerService.track(.tapScanBarcode(context: BarcodeScannerOpenContext.quickEntryPanel.rawValue))
        }
        presentFoodLogScreen(mealType: mealType, context: context)
    }

    private func presentFoodLogScreen(mealType: MealType, context: FoodLogContext) {
        guard hasSubscription || freeUsageService.canAddToDay(currentDay) else {
            presentPaywallAndLogFood(mealType: mealType, context: context)
            return
        }
        output(.switchTabBar(isHidden: true))
        router.dismissBanner()
        let input = foodLogInput(mealType: mealType, context: context)
        router.presentFoodLogScreen(input: input) { [weak self] output in
            switch output {
            case .closed:
                self?.output(.switchTabBar(isHidden: false))
            }
        }
    }

    private func foodLogInput(mealType: MealType, context: FoodLogContext) -> FoodLogInput {
        FoodLogInput(
            mealType: mealType,
            dayDate: currentDay,
            context: context,
            initialMeal: records(for: currentDay).first(where: { $0.type == mealType })?.meals ?? [],
            hasSubscription: hasSubscription,
            mealsCountInDay: meals(for: currentDay).count
        )
    }

    private func presentPaywallAndLogFood(mealType: MealType, context: FoodLogContext) {
        presentPaywall(context: context == .barcode ? .barcodeScanner : .logLimit) { [weak self] in
            self?.presentFoodLogScreen(mealType: mealType, context: context)
        }
    }

    private func observeFoodLogPublisher(publisher: AnyPublisher<MealType, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, type in
                this.trackTapAddFood(type: type, context: .plusMenu)
                this.addMeal(type: type, context: .input)
            }
            .store(in: &cancellables)
    }

    private func observeProfileUpdatePublisher(publisher: AnyPublisher<Void, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.updateProfile(date: this.currentDay)
            }
            .store(in: &cancellables)
    }

    private func observeSubscription() {
        subscriptionService.hasSubscriptionObservable
            .asDriver()
            .drive(with: self) { this, hasSubscription in
                this.hasSubscription = hasSubscription
            }
            .disposed(by: disposeBag)
    }

    private func updateTabViewId() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tabViewId = .init()
        }
    }
}

// MARK: Discount experiment

extension FoodViewModel {
    func bannerTapped() {
        if let discountPaywallInfo {
            router.presentDiscountPaywall(input: .init(context: .discountMain,
                                                       paywallInfo: discountPaywallInfo)) { [weak self] _ in
                self?.router.dismiss()
            }
        }
    }

    func updateTimer() {
        guard let discountPaywallInfo, let interval = discountPaywallTimerService.getCurrentTimer(
            durationInSeconds: discountPaywallInfo.timerDurationInSeconds
        ) else {
            return
        }

        timerInterval = interval
    }

    func closeBannerTapped() {
        discountPaywallTimerService.stopTimer()
    }

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    private func initializeDiscountPaywallExperiment() {
        appCustomization.discountPaywallExperiment
            .take(1)
            .asDriver()
            .drive(with: self) { this, paywallIInfo in
                this.discountPaywallTimerService.registerPaywall(info: paywallIInfo)

                this.updateTimer()
                this.startTimer()
            }
            .disposed(by: disposeBag)
    }

    private func startTimer() {
        Publishers.Merge(timer, Just(.now))
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.timerInterval -= .second

                if this.timerInterval.seconds <= 0 {
                    this.discountPaywallTimerService.setAvailableDiscount(data: nil)
                    this.timer.upstream.connect().cancel()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Analytics
extension FoodViewModel {
    func trackTapOpenContainer(type: MealType) {
        trackerService.track(.tapOpenContainer(container: type.rawValue))
    }

    func trackTapAddFood(type: MealType, context: ContainerOpenContext) {
        trackerService.track(.tapAddToContainer(container: type.rawValue, context: context.rawValue))
    }
}
