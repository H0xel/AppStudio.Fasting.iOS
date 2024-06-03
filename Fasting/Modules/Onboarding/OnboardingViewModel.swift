//  
//  OnboardingViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies
import AICoach
import AppStudioModels
import WeightGoalWidget
import WeightWidget

class OnboardingViewModel: BaseViewModel<OnboardingOutput> {
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.cloudStorage) private var cloudStorage

    var router: OnboardingRouter!
    @Published var step: OnboardingFlowStep = .none
    @Published var sex: Sex?
    @Published var activityLevel: ActivityLevel?
    @Published var fastingGoals: [FastingGoal] = []
    @Published var specialEvent: SpecialEvent?
    @Published var birthdayDate: Date = .dateWith(day: 1, month: 1, year: 2000)
    @Published var specialEventDate: Date = .now.adding(.month, value: 1)
    @Published var height: CGFloat = 0
    @Published var inchHeight: CGFloat = 0
    @Published var currentWeight: CGFloat = 0
    @Published var desiredWeight: CGFloat = 0
    @Published var heightUnit: HeightUnit = .ft
    @Published var weightUnit: WeightUnit = .lb
    @Published var isMovingForward = true
    @Published var isLongOnboadingEnabled = false
    @Published private var hasSubscription = false

    init(input: OnboardingInput, output: @escaping OnboardingOutputBlock) {
        super.init(output: output)
        initialize()
        subscribeToHasSubscription()
    }

    var isNextButtonEnabled: Bool {
        switch step {
        case .start:
            true
        case .fastingGoal:
            !fastingGoals.isEmpty
        case .sex:
            sex != nil
        case .birthday:
            true
        case .height:
            height > 0
        case .currentWeight:
            currentWeight > 0
        case .desiredWeight:
            desiredWeight > 0
        case .activityLevel:
            activityLevel != nil
        case .specialEvent:
            specialEvent != nil
        case .specialEventDate:
            true
        case .none:
            false
        }
    }

    var canShowNextButton: Bool {
        switch step {
        case .none, .start:
            return false
        default:
            return true
        }
    }

    var canShowPrevButton: Bool {
        switch step {
        case .none, .start, .fastingGoal:
            return false
        default:
            return true
        }
    }

    func fastingGoalTapped(_ goal: FastingGoal) {
        if let index = fastingGoals.firstIndex(of: goal) {
            fastingGoals.remove(at: index)
        } else {
            fastingGoals.append(goal)
        }
    }

    func activityLevelTapped(_ activityLevel: ActivityLevel) {
        self.activityLevel = activityLevel
    }

    func sexTapped(_ sex: Sex) {
        self.sex = sex
    }

    func specialEventTapped(_ event: SpecialEvent) {
        specialEvent = event
    }

    func nextStep() {
        isMovingForward = true
        trackNextStep()

        if step == .start, cloudStorage.userWithOnboardingApi {
            router.pushChooseFastingScreen { [weak self] output in
                switch output {
                case .onboardingIsFinished:
                    self?.output(.onboardingIsFinished)
                }
            }
        }

        if step == .start, !isLongOnboadingEnabled, !hasSubscription {
            presentPaywall()
            return
        }
        guard let nextStep = OnboardingFlowStep(rawValue: step.rawValue + 1) else {
            finishOnboarding()
            return
        }
        if nextStep != .specialEventDate || specialEvent != .noSpecialEvent {
            step = nextStep
        } else {
            finishOnboarding()
        }
    }

    func prevStep() {
        isMovingForward = false
        if let prevStep = OnboardingFlowStep(rawValue: step.rawValue - 1) {
            step = prevStep
        }
    }

    private func initialize() {
        Task {
            let isLongOnboardingEnabled = try await appCustomization.isLongOnboardingEnabled()
            await MainActor.run { [weak self] in
                self?.isLongOnboadingEnabled = isLongOnboardingEnabled
                self?.step = .start
            }
        }
    }

    private func subscribeToHasSubscription() {
        newSubscriptionService.hasSubscription
            .assign(to: &$hasSubscription)
    }

    private func presentPaywall() {
        if let input = onboardingService.paywallInput {
            router.presentPersonalizedPaywall(input: input) { [weak self] event in
                switch event {
                case .onboardingIsFinished:
                    self?.output(.onboardingIsFinished)
                }
            }
            return
        }
        router.presentPaywall { [weak self] output in
            switch output {
            case .onboardingIsFinished:
                self?.output(.onboardingIsFinished)
            }
        }
    }

    private func finishOnboarding() {
        userPropertyService.set(userProperties: [
            "sex": sex?.rawValue ?? "",
            "birthday": birthdayDate.description,
            "height": height,
            "starting_weight": currentWeight,
            "target_weight": desiredWeight,
            "activity_level": activityLevel?.rawValue ?? ""
        ])
        guard let sex,
              let activityLevel,
              let specialEvent
        else {
            return
        }

        let onboardingData = OnboardingData(
            goals: Set(fastingGoals),
            sex: sex,
            birthdayDate: birthdayDate,
            height: heightUnit == .cm ?
                .init(centimeters: height) :
                .init(feet: height, inches: inchHeight),
            weight: WeightMeasure(value: currentWeight, units: weightUnit),
            desiredWeight: WeightMeasure(value: desiredWeight, units: weightUnit),
            activityLevel: activityLevel,
            specialEvent: specialEvent,
            specialEventDate: specialEventDate
        )
        onboardingService.save(data: onboardingData)

        router.presentLoadingView { [weak self] in
            if self?.hasSubscription == false {
                self?.presentPaywall()
                return
            }
            self?.router.pushChooseFastingScreen { [weak self] output in
                switch output {
                case .onboardingIsFinished:
                    self?.output(.onboardingIsFinished)
                }
            }
        }
    }
}

private extension OnboardingViewModel {
    // swiftlint:disable cyclomatic_complexity
    func trackNextStep() {
        switch step {
        case .start:
            trackerService.track(.tapGetStarted)
        case .fastingGoal:
            goalAnswered()
        case .sex:
            trackerService.track(.sexAnswered(sex: sex?.rawValue ?? ""))
        case .birthday:
            trackerService.track(.birthdayAnswered(date: birthdayDate.description))
        case .height:
            trackerService.track(.heightAnswered(height: height, units: heightUnit.rawValue))
        case .currentWeight:
            trackerService.track(.startingWeightAnswered(startingWeight: currentWeight,
                                                         units: weightUnit.rawValue))
        case .desiredWeight:
            trackerService.track(.targetWeightAnswered(targetWeight: desiredWeight,
                                                       units: weightUnit.rawValue))
        case .activityLevel:
            trackerService.track(.activityLevelAnswered(activityLevel: activityLevel?.rawValue ?? ""))
        case .specialEvent:
            trackerService.track(.specialEventAnswered(event: specialEvent?.rawValue ?? ""))
        case .specialEventDate:
            trackerService.track(.eventDateAnswered(date: specialEventDate.description))
        case .none:
            break
        }
    }

    private func goalAnswered() {
        let goals = Set(fastingGoals)
        trackerService.track(.goalAnswered(loseWeight: goals.contains(.loseWeight),
                                           lookBetter: goals.contains(.lookBetter),
                                           feelEnergetic: goals.contains(.feelMoreEnergetic),
                                           mentalClarity: goals.contains(.improveMentalClarity),
                                           liveLonger: goals.contains(.liveLonger),
                                           healthierLifestyle: goals.contains(.healthierLifestyle)))
    }
}
