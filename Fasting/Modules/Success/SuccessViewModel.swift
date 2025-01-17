//  
//  SuccessViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies

class SuccessViewModel: BaseViewModel<SuccessOutput> {

    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Published private var plan: FastingPlan
    @Published private var startDate: Date
    @Published private var endDate: Date
    private let isEmpty: Bool
    var router: SuccessRouter!

    init(input: SuccessInput, output: @escaping SuccessOutputBlock) {
        plan = input.plan
        startDate = input.startDate
        endDate = input.endDate
        isEmpty = input.isEmpty
        super.init(output: output)
    }

    var fastingTime: String {
        fastingInterval.toTime
    }

    var resultImage: Image {
        switch plan {
        case .beginner:
            beginerPlanImage
        case .regular, .expert:
            regularAndExpertPlanImage
        }
    }

    var resultTitle: String {
        if isEmpty {
            return "SuccessScreen.logFast".localized()
        }
        if fastingInterval < plan.duration {
            return NSLocalizedString("SuccessScreen.striveForProgress", comment: "")
        }
        if fastingInterval - plan.duration > .hour {
            return NSLocalizedString("SuccessScreen.outdoneYourself", comment: "")
        }
        return NSLocalizedString("SuccessScreen.fastingChampion", comment: "")
    }

    var resultSubtitle: String? {
        let difference = fastingInterval - plan.duration
        if difference > .hour {
            let subtitle = NSLocalizedString("SuccessScreen.youFastedFor", comment: "")
            return String(format: subtitle, "\(difference.toTime)")
        }
        return nil
    }

    var fastingStartTime: String {
        fastingDateString(startDate)
    }

    var fastingEndTime: String {
        fastingDateString(endDate)
    }

    func submit() {
        output(.submit(startDate: startDate, endDate: endDate))
        trackFastingProperties()
        trackFastingFinished()
        router.dismiss()
    }

    func dismiss() {
        router.dismiss()
        trackTapCancelFasting()
    }

    func editStartDate() {
        let input = StartFastingInput.startFasting(context: .endFasting,
                                                   isActiveState: true,
                                                   initialDate: startDate,
                                                   minDate: startDate.adding(.day, value: -2),
                                                   maxDate: endDate,
                                                   components: [.date, .hourAndMinute])
        router.presentEditFastingTime(input: input) { [weak self] event in
            switch event {
            case .save(let date):
                DispatchQueue.main.async {
                    self?.startDate = date
                }
            }
        }
        trackTapChangeFastingStartTime()
    }

    func editEndDate() {
        let input = StartFastingInput.endFasting(initialDate: endDate,
                                                 minDate: startDate,
                                                 maxDate: isEmpty ? endDate.add(days: 2) : .now)
        router.presentEditFastingTime(input: input) { [weak self] event in
            switch event {
            case .save(let date):
                DispatchQueue.main.async {
                    self?.endDate = date
                }
            }
        }
        trackTapChangeFastingEndTime()
    }

    private var fastingInterval: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    private func fastingDateString(_ date: Date) -> String {
        if date.isSameDay(with: .now) {
            return NSLocalizedString("TodayTitle", comment: "Today") + ", " + date.localeTimeString
        }
        return date.localeDateTimeString
    }

    private var beginerPlanImage: Image {
        switch fastingInterval.fastingStage {
        case .sugarRises:
            Image("beginnerOneStageCompleted")
        case .sugarDrop:
            Image("beginnerTwoStagesCompleted")
        case .sugarNormal:
            Image("beginnerThreeStagesCompleted")
        case .burning:
            Image("beginnerFourStagesCompleted")
        case .ketosis:
            Image("beginnerFiveStagesCompleted")
        case .autophagy:
            Image("regularSixStagesCompleted")
        }
    }

    private var regularAndExpertPlanImage: Image {
        switch fastingInterval.fastingStage {
        case .sugarRises:
            Image("regularOneStageCompleted")
        case .sugarDrop:
            Image("regularTwoStagesCompleted")
        case .sugarNormal:
            Image("regularThreeStagesCompleted")
        case .burning:
            Image("regularFourStagesCompleted")
        case .ketosis:
            Image("regularFiveStagesCompleted")
        case .autophagy:
            Image("regularSixStagesCompleted")
        }
    }
}

extension SuccessViewModel {
    func trackTapChangeFastingStartTime() {
        trackerService.track(.tapChangeFastingStartTime(context: .endFasting))
    }

    func trackTapChangeFastingEndTime() {
        trackerService.track(.tapChangeFastingEndTime)
    }

    func trackTapCancelFasting() {
        trackerService.track(.tapCancelFasting(context: .endFasting))
    }

    func trackFastingFinished() {
        trackerService.track(.fastingFinished(
            timeFasted: fastingInterval.toTime,
            startTime: startDate.description,
            currentTime: Date.now.description,
            schedule: plan.description)
        )
    }

    func trackFastingProperties() {
        userPropertyService.incrementProperty(property: "fasting_cycles_count", value: 1)
        userPropertyService.incrementProperty(property: "hours_fasted_count", value: fastingInterval.toHour)
    }
}
