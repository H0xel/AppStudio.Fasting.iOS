//  
//  OnboardingViewModel.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 12.09.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies
import NewAppStudioSubscriptions
import AppStudioStyles

class OnboardingViewModel: BaseViewModel<OnboardingOutput> {
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.onboardingUserDataService) private var onboardingUserDataService

    var router: OnboardingRouter!
    @Published private(set) var step: OnboardingFlowStep = .none
    @Published private(set) var isMovingForward = true
    @Published var onboardingData: OnboardingData = .initial
    @Published private var hasSubscription = false
    let steps: [OnboardingFlowStep]

    @Published var startPointLastPeriod: CGFloat = 5 {
        willSet {
            if newValue < 3 || newValue > 17 {
                statusLastPeriod = .notNormal
                return
            }
            statusLastPeriod = .normal
        }
    }

    @Published var startPointTypicalMenstrualCycle: CGFloat = 5 {
        willSet {
            if newValue < 3 || newValue > 17 {
                statusMenstrualCycle = .notNormal
                return
            }
            statusMenstrualCycle = .normal
        }
    }

    @Published var statusLastPeriod: OnboardingFastCalorieStatusView.ViewData = .normal
    @Published var statusMenstrualCycle: OnboardingFastCalorieStatusView.ViewData = .normal

    private var filteredSteps: [OnboardingFlowStep] {
        return steps
    }

    init(input: OnboardingInput, output: @escaping OnboardingOutputBlock) {
        steps = input.steps
        super.init(output: output)
        initialize()
    }

    var isNextButtonEnabled: Bool {
        switch step {
        case .start:
            true
        case .currentWeight:
            onboardingData.currentWeight > 0
        case .regularIrregularCycle:
            onboardingData.cyclePeriod != nil
        case .useOfBrithControl:
            onboardingData.useOfBirthControl != nil
        case .fertilityGoals:
            !onboardingData.fertilityGoals.isEmpty
        case .topics:
            !onboardingData.topics.isEmpty
        case .features:
            !onboardingData.features.isEmpty
        case .none:
            false
        default:
            true
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
        case .none, .start:
            return false
        default:
            return true
        }
    }

    func nextStep() {
        isMovingForward = true
//        trackNextStep()

        let steps = filteredSteps

        guard let currentStepIndex = steps.firstIndex(of: step),
              currentStepIndex + 1 < steps.count else {
            finishOnboarding()
            return
        }
        let nextStep = steps[currentStepIndex + 1]

        step = nextStep
    }

    func prevStep() {
        isMovingForward = false

        let steps = filteredSteps

        guard let currentStepIndex = steps.firstIndex(of: step),
              currentStepIndex - 1 >= 0 else {
            return
        }
        let prevStep = steps[currentStepIndex - 1]
        step = prevStep
    }

    func handle(_ event: OnboardingStartView.Action) {
        switch event {
        case.getStartedTapped:
            nextStep()
        case .w2wSignIn, .intercome:
            //TODO: сделать обратботку когда будем затаскивать w2w/intercom
            break
        }
    }

    private func finishOnboarding() {
//        let calculation = calculation
//        setUserProperties(calculation: calculation)
//        trackOnboardingFinished(calculation: calculation)
        saveUserData()
        router.presentLoadingView { [weak self] in
            guard let self else { return }
            self.presentPeriodOnboardingDetails()
        }
    }

    private func presentPeriodOnboardingDetails() {
        router.presentPeriodOnboardingDetails { [weak self] output in
            guard let self else { return }
            switch output {
            case .backTapped:
                self.router.dismiss()
            case .nextTapped:
                if !hasSubscription {
                    self.presentPaywall()
                    return
                }
                self.output(.onboardingIsFinished)
            }
        }
    }

    private func presentPaywall() {
        router.presentPaywall { [weak self] in
            self?.output(.onboardingIsFinished)
        }
    }

    private func saveUserData() {
        onboardingUserDataService.save(onboardingData)
    }

    private func initialize() {
        newSubscriptionService.hasSubscription.assign(to: &$hasSubscription)

        Task {
            await MainActor.run { [weak self] in
                if let step = self?.steps.first(where: { $0 != .none }) {
                    self?.step = step
                }
            }
        }
    }
}
