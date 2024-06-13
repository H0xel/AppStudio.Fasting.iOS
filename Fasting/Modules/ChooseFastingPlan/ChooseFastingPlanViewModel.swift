//  
//  ChooseFastingPlanViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies

class ChooseFastingPlanViewModel: BaseViewModel<ChooseFastingPlanOutput> {
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    var router: ChooseFastingPlanRouter!
    let context: ChooseFastingPlanInput.Context

    let plans: [FastViewPlan] = [.init(plan: .regular), .init(plan: .beginner), .init(plan: .expert)]
    @Published var index = 0
    @Published private var previousPlan: FastingPlan = .beginner
    @Published var showW2WActivationBanner = false

    init(input: ChooseFastingPlanInput, output: @escaping ChooseFastingPlanOutputBlock) {
        context = input.context
        super.init(output: output)
        trackFastingScheduleScreenShownIfNeeded()
        subscribeToPreviousPlan()

        if context == .w2wOnboarding {
            Task { @MainActor in
                showW2WActivationBanner = true
                try await Task.sleep(seconds: 3)
                showW2WActivationBanner = false
            }
        }
    }

    func choosePlanTapped() {
        let plan = plans[index].plan
        trackScheduleSet(
            schedule: plan.description,
            previousSchedule: previousPlan.description,
            context: context
        )

        router.showSetupFastingScreen(context: .init(context), plan: plan) { [weak self] event in
            guard let self else { return }
            switch event {
            case .onboardingIsFinished:
                self.output(.onboardingIsFinished)
            }
        }
    }

    func backButtonTapped() {
        router.dismiss()
    }

    private func subscribeToPreviousPlan() {
        fastingParametersService.fastingIntervalPublisher
            .map(\.plan)
            .assign(to: &$previousPlan)
    }
}

struct FastViewPlan: Hashable {
    let plan: FastingPlan
}

private extension ChooseFastingPlanViewModel {
    func trackFastingScheduleScreenShownIfNeeded() {
        if context == .onboarding {
            trackerService.track(.fastingScheduleScreenShown)
        }
    }

    func trackScheduleSet(schedule: String, previousSchedule: String, context: ChooseFastingPlanInput.Context) {
        trackerService.track(.scheduleSet(
            schedule: schedule,
            previousSchedule: context != .onboarding ? previousSchedule : "",
            context: context)
        )
    }
}
