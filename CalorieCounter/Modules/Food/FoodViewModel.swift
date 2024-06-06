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
import AppStudioServices
import AppStudioModels
import AppStudioStyles
import UserNotifications

class FoodViewModel: BaseViewModel<FoodOutput> {
    var router: FoodRouter!
    @Published var hasSubscription = false
    @Published var discountPaywallInfo: DiscountPaywallInfo?
    @Published var timerInterval: TimeInterval = .second
    let swipeDaysViewModel = SwipeDaysViewModel(isFutureAllowed: true)
    let calendarViewModel = CalendarProgressViewModel(isFutureAllowed: true, withFullProgress: true)
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let disposeBag = DisposeBag()
    private let focusTextFieldSubject = PassthroughSubject<(Date, FoodLogContext), Never>()
    private let foodLogSubject = PassthroughSubject<(Date, MealType), Never>()
    private let updateProfileSubject = PassthroughSubject<Void, Never>()

    @Dependency(\.newSubscriptionService) private var subscriptionService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.mealService) private var mealService
    @Dependency(\.userDataService) private var userDataService
    @Dependency(\.localNotificationService) private var localNotificationService
    @Dependency(\.storageService) private var storageService
    @Dependency(\.intercomService) private var intercomService

    init(input: FoodInput, output: @escaping FoodOutputBlock) {
        super.init(output: output)
        observeFoodLogPublisher(publisher: input.presentFoodLogPublisher)
        observeSubscription()
        initializeDiscountPaywallExperiment()
        subscribeForAvailableDiscountPaywall()
        initializeCalendar()
        requestLocalNotifications()
    }

    func dayFoodInput(date: Date) -> DayFoodInput {
        .init(date: date,
              router: router,
              focusTextFieldPublisher: focusTextFieldSubject.eraseToAnyPublisher(),
              foodLogPublisher: foodLogSubject.eraseToAnyPublisher(),
              updateProfilePublisher: updateProfileSubject.eraseToAnyPublisher())
    }

    func handle(dayFoodOutput output: DayFoodOutput) {
        switch output {
        case .banner:
            bannerTapped()
        case .closeBanner:
            closeBannerTapped()
        case .switchTabBar(let isHidden):
            self.output(.switchTabBar(isHidden: isHidden))
        case let .dayProgress(date, progress):
            calendarViewModel.updateProgress(date: date, progress: progress)
        }
    }

    func presentTextField(isFocused: Bool) {
        router.presentTextField { [weak self] in
            guard let self else { return }
            self.focusTextFieldSubject.send((calendarViewModel.currentDay, .input))
        } onBarcodeScan: { [weak self] accessGranted in
            guard let self, accessGranted else {
                self?.router.presentCameraAccessAlert()
                return
            }
            self.focusTextFieldSubject.send((calendarViewModel.currentDay, .barcode))
        }
    }

    func presentProfile() {
        router.presentProfile { [weak self] output in
            switch output {
            case .switchTabBar(let isHidden):
                break
            case .updateProfile:
                self?.updateProfileSubject.send()
            }
        }
    }

    private func initializeCalendar() {
        swipeDaysViewModel.initialize { [weak self] output in
            guard let self else { return }
            switch output {
            case .dateUpdated(let date):
                self.calendarViewModel.updateCurrentDay(for: date)
            }
        }

        calendarViewModel.initialize { [weak self] output in
            switch output {
            case .dateChange(let date):
                self?.swipeDaysViewModel.updateCurrentDate(to: date)
                self?.trackerService.track(.tapDate(date: date.description))
            case .updateProgress(let weeks):
                self?.updateMealProgress(weeks: weeks)
            case .swipeDirection(let direction):
                self?.trackerService.track(.swipeWeek(direction: direction.rawValue))
            }
        }
    }

    private func updateMealProgress(weeks: [Week]) {
        Task { [weak self] in
            guard let self else { return }
            let days = weeks.days

            for day in days {
                async let profile = userDataService.nutritionProfile(dayDate: day)
                async let meals = mealService.meals(forDay: day, type: nil)

                let dayProgress = try await DayProgress(
                    goal: profile.calories,
                    result: meals.reduce(0) { $0 + $1.calories }
                )
                await MainActor.run {
                    self.calendarViewModel.updateProgress(date:day, progress: dayProgress)
                }
                await Task.yield()
            }
        }
    }

    private func observeFoodLogPublisher(publisher: AnyPublisher<MealType, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, type in
                this.foodLogSubject.send((this.calendarViewModel.currentDay, type))
            }
            .store(in: &cancellables)
    }

    private func observeSubscription() {
        subscriptionService.hasSubscription
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, hasSubscription in
                this.hasSubscription = hasSubscription
                if hasSubscription {
                    this.deleteDiscountNotification()
                }
            }
            .store(in: &cancellables)
    }

    func trackNextDay(_ date: Date) {
        trackerService.track(.tapNextDay(targetDate: date.description))
    }

    func trackPrevDay(_ date: Date) {
        trackerService.track(.tapPreviousDay(targetDate: date.description))
    }
    
    func handleDeepLink(deepLink: DeepLink?) {
        switch deepLink {
        case .discount:
            presentDiscountPaywall(context: .discountPush)
        case .intercom:
            Task {
                await router.popToRoot()
                intercomService.hideIntercom()
                intercomService.presentIntercom()
                    .sink { _ in }
                    .store(in: &cancellables)
            }
        case .none: break
        }
    }
}

// MARK: Discount experiment

extension FoodViewModel {
    func bannerTapped() {
        presentDiscountPaywall(context: .discountMain)
    }

    func updateTimer(discountPaywallInfo: DiscountPaywallInfo) {
        guard let interval = discountPaywallTimerService.getCurrentTimer(
            durationInSeconds: discountPaywallInfo.timerDurationInSeconds ?? 0
        ) else {
            return
        }

        timerInterval = interval
    }

    func closeBannerTapped() {
        discountPaywallTimerService.stopTimer()
    }
    
    private func presentDiscountPaywall(context: PaywallContext) {
        if let discountPaywallInfo {
            router.presentDiscountPaywall(input: .init(context: context,
                                                       paywallInfo: discountPaywallInfo)) { [weak self] _ in
                self?.router.dismiss()
            }
        }
    }

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .receive(on: DispatchQueue.main)
            .assign(to: &$discountPaywallInfo)
    }

    private func initializeDiscountPaywallExperiment() {
        appCustomization.discountPaywallExperiment
            .take(1)
            .asDriver()
            .drive(with: self) { this, paywallIInfo in
                if let paywallIInfo {                    
                    this.discountPaywallTimerService.registerPaywall(info: paywallIInfo)
                    this.updateTimer(discountPaywallInfo: paywallIInfo)
                    this.startTimer()
                }
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
    
    private func requestLocalNotifications() {
        Task {
            let authorizationIsGranted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            await UIApplication.shared.registerForRemoteNotifications()
            if authorizationIsGranted, !storageService.discountNotificationRegistered {
                registerDiscountNotification()
            }
        }
    }
    
    private func registerDiscountNotification() {
        guard let notificationStartedDate = discountPaywallTimerService.delayedTimerDate, !hasSubscription else { return }
        Task {
            try await localNotificationService.register(DiscountLocalNotification(), 
                                                        at: .init(year: notificationStartedDate.year,
                                                                  month: notificationStartedDate.month,
                                                                  day: notificationStartedDate.day,
                                                                  hour: notificationStartedDate.hour,
                                                                  minute: notificationStartedDate.minute,
                                                                  second: notificationStartedDate.second))
            storageService.discountNotificationRegistered = true
        }
    }
    
    private func deleteDiscountNotification() {
        localNotificationService.clearPendingNotification(id: DiscountLocalNotification().id)
    }
}
