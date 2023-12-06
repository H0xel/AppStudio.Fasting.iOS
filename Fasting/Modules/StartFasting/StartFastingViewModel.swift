//  
//  StartFastingViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies

class StartFastingViewModel: BaseViewModel<StartFastingOutput> {
    @Dependency(\.trackerService) private var trackerService

    @Published var fastTime: Date
    let title: LocalizedStringKey
    let dateComponents: DatePickerComponents
    let datesRange: ClosedRange<Date>
    private let initialTime: Date
    private let context: StartFastingInput.Context
    private let kind: StartFastingInput.Kind

    var router: StartFastingRouter!

    init(input: StartFastingInput, output: @escaping StartFastingOutputBlock) {
        fastTime = input.initialDate
        initialTime = input.initialDate
        context = input.context
        kind = input.kind

        title = input.title
        dateComponents = input.datePickerComponents
        datesRange = input.datesRange
        super.init(output: output)
    }

    func save() {
        Task { [weak self] in
            guard let self else { return }
            await self.router.dismiss()
            trackTapSaveFasting()
            self.output(.save(fastTime))
        }
        trackFastingTimeChanged()
    }

    func cancel() {
        trackTapCancelFasting()
        router.dismiss()
    }
}

private extension StartFastingViewModel {
    func trackTapSaveFasting() {
        trackerService.track(.tapSaveStartFasting(currentTime: Date.now.description, startTime: fastTime.description))
    }

    func trackTapCancelFasting() {
        trackerService.track(.tapCancelStartFasting)
    }

    func trackFastingTimeChanged() {
        if kind == .endTime {
            trackerService.track(.fastingEndTimeChanged(
                oldEndTime: initialTime.description,
                newStartTime: fastTime.description)
            )
        }

        if kind == .startTime {
            trackerService.track(.fastingStartTimeChanged(
                oldEndTime: initialTime.description,
                newStartTime: fastTime.description,
                fastingInitiated: fastTime < Date.now,
                context: context)
            )
        }
    }
}
