//  
//  SetupFastingViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import AppStudioFoundation
import Foundation
import Dependencies

class SetupFastingViewModel: BaseViewModel<SetupFastingOutput> {
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.trackerService) private var trackerService

    @Published var startFastingDate: Date = .now
    @Published var title = ""

    let plan: FastingPlan
    let context: SetupFastingInput.Context
    var router: SetupFastingRouter!

    init(input: SetupFastingInput, output: @escaping SetupFastingOutputBlock) {
        self.context = input.context
        self.plan = input.plan
        super.init(output: output)
        subscribeToStartingDate()
        if context == .onboarding {
            startFastingDate = DateComponents(calendar: .current,
                                                 year: Date().year,
                                                 month: Date().month,
                                                 day: Date().day,
                                                 hour: 20).date ?? .now
            return
        }
        subscripeToInitialStartingDate()
    }

    func saveTapped() {
        trackGlobalTimeSet(startTime: startFastingDate.description, schedule: plan.description, context: .init(context))
        if context == . onboarding {
            router.pushNotificationOnboarding { [weak self] event in
                guard let self else { return }
                switch event {
                case .onboardingIsFinished:
                    Task { [weak self] in
                        guard let self else { return }
                        try await self.fastingParametersService.set(
                            fastingInterval: FastingInterval(start: self.startFastingDate, plan: self.plan)
                        )
                        trackOnboardingFinished(schedule: plan.description, startTime: startFastingDate.description)
                        self.output(.onboardingIsFinished)
                    }
                }
            }
        }

        if context == .profile || context == .fasting || context == .daily {
            Task { [weak self] in
                guard let self else { return }
                try await self.fastingParametersService.set(
                    fastingInterval: FastingInterval(start: self.startFastingDate, plan: self.plan)
                )
                await self.router.popToRoot()
            }
        }
    }

    func changeTapped() {
        if context == .onboarding || context == .profile {
            router.dismiss()
        }

        if context == .fasting || context == .daily {
            router.presentChooseFasting(context: .init(context))
        }

        trackChangeTapped(currentSchedule: plan.description, context: .init(context))
    }

    func backButtonTapped() {
        router.dismiss()
    }

    private func subscripeToInitialStartingDate() {
        fastingParametersService
            .fastingIntervalPublisher
            .receive(on: DispatchQueue.main)
            .map(\.start)
            .assign(to: &$startFastingDate)
    }

    private func subscribeToStartingDate() {
        $startFastingDate.sink(with: self) { this, date in
            let dateWithFasting = date.addingTimeInterval(this.plan.duration)
            let endingFasting: String = " \(dateWithFasting.localeTimeString.lowercased())"

            let title = NSLocalizedString(
                dateWithFasting.isSameDay(with: .now)
                ? "SetupFasting.sameDay"
                : "SetupFasting.followingDay",
                comment: "Fasting end at") + endingFasting

            this.title = title
        }
        .store(in: &cancellables)
    }
}

private extension SetupFastingViewModel {
    func trackOnboardingFinished(schedule: String, startTime: String) {
        trackerService.track(.onboardingFinished(schedule: schedule, startTime: startTime.lowercased()))
    }

    func trackGlobalTimeSet(startTime: String, schedule: String, context: ChooseFastingPlanInput.Context) {
        trackerService.track(.globalTimeSet(
            startTime: startTime.lowercased(),
            schedule: schedule,
            context: context)
        )
    }

    func trackChangeTapped(currentSchedule: String, context: ChooseFastingPlanInput.Context) {
        trackerService.track(.tapChangeSchedule(currentSchedule: currentSchedule, context: context))
    }
}
