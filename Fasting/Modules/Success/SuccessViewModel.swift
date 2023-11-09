//  
//  SuccessViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class SuccessViewModel: BaseViewModel<SuccessOutput> {

    @Published private var plan: FastingPlan
    @Published private var startDate: Date
    @Published private var endDate: Date

    var router: SuccessRouter!

    init(input: SuccessInput, output: @escaping SuccessOutputBlock) {
        plan = input.plan
        startDate = input.startDate
        endDate = input.endDate
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
        router.dismiss()
    }

    func dismiss() {
        router.dismiss()
    }

    func editStartDate() {
        let input = StartFastingInput.startFasting(initialDate: startDate,
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
    }

    func editEndDate() {
        let input = StartFastingInput.endFasting(initialDate: endDate, minDate: startDate)
        router.presentEditFastingTime(input: input) { [weak self] event in
            switch event {
            case .save(let date):
                DispatchQueue.main.async {
                    self?.endDate = date
                }
            }
        }
    }

    private var fastingInterval: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    private func fastingDateString(_ date: Date) -> String {
        if date.isSameDay(with: .now) {
            return NSLocalizedString("TodayTitle", comment: "Today") + ", " + date.currentLocaleFormatted(with: "hhmm")
        }
        return date.currentLocaleFormatted(with: "MMMMdhhmm")
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
        case .ketosis, .autophagy:
            Image("beginnerFiveStagesCompleted")
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
