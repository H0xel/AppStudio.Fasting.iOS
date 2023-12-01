//
//  FastingInterval.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

struct FastingInterval {
    let start: Date
    let plan: FastingPlan
    var currentDate: Date?

    init(start: Date, plan: FastingPlan, currentDate: Date? = nil) {
        self.start = start.withoutSeconds
        self.plan = plan
        self.currentDate = currentDate?.withoutSeconds
    }
    /// nearest date of start fasting
    var startDate: Date {
        currentDate ?? nearestStartDate
    }

    var checkedCurrentDate: Date? {
        guard let currentDate else {
            return nil
        }
        let lastEnoughDate = Date.now.addingTimeInterval( -1 * (plan.duration + .hour))
        let isEnoughInterval = lastEnoughDate.timeIntervalSince(currentDate)
        return isEnoughInterval < 0 ? currentDate : nil
    }

    var minAllowedCurrentDate: Date {
        Date.now.addingTimeInterval( -1 * (plan.duration + .hour))
    }

    var endDate: Date {
        startDate.addingTimeInterval(plan.duration)
    }

    var nearestStartDate: Date {
        guard let todayDate = Date.now.takeTime(from: start) else {
            return start
        }

        let dates = [todayDate.addingTimeInterval(.day * -1), todayDate.addingTimeInterval(.day)]

        var result = todayDate
        var interval = abs(Date().timeIntervalSince(result))
        for date in dates {
            let dateInterval = abs(Date().timeIntervalSince(date))
            if dateInterval < interval {
                interval = dateInterval
                result = date
            }
        }
        return result
    }

    var nextStartDate: Date {
        guard let todayDate = Date.now.takeTime(from: start) else {
            return start
        }
        if todayDate.timeIntervalSinceNow < 0 {
            return todayDate
        }
        return todayDate.addingTimeInterval(.day)
    }

    private var currentFastingInterval: TimeInterval {
        startDate.timeIntervalSinceNow * -1
    }

    private var beforeStartInterval: TimeInterval {
        startDate.timeIntervalSinceNow
    }

    private var currentActiveStage: FastingStage {
        switch currentFastingInterval {
        case 0 ... .hour * 2:
            return .sugarRises
        case .hour * 2 ... .hour * 8:
            return .sugarDrop
        case .hour * 8 ... .hour * 10:
            return .sugarNormal
        case .hour * 10 ... .hour * 14:
            return .burning
        case .hour * 14 ... .hour * 16:
            return .ketosis
        default:
            return .autophagy
        }
    }

    private var isFinished: Bool {
        currentFastingInterval > plan.duration
    }

    private var isExpiredTime: Bool {
        currentFastingInterval > 0
    }

    func status(isFastingProcessRunning: Bool) -> FastingStatus {
        if isFastingProcessRunning {
            return .active(FastingActiveState(interval: currentFastingInterval,
                                              stage: currentActiveStage,
                                              isFinished: isFinished))
        }

        return isExpiredTime ? .inActive(.expired) : .inActive(.left(beforeStartInterval))
    }
}

extension FastingInterval {
    static var empty: FastingInterval {
        .init(start: .now, plan: .beginner)
    }
}

extension FastingInterval: Equatable {
    func isParametersChanged(_ interval: FastingInterval) -> Bool {
        start != interval.start || plan != interval.plan
    }
}

extension Date {
    func takeTime(from otherDate: Date) -> Date? {
        let components = self.dateComponents
        let otherComponents = otherDate.dateComponents

        let resultComponents = DateComponents(
            calendar: .current,
            year: components.year,
            month: components.month,
            day: components.day,
            hour: otherComponents.hour,
            minute: otherComponents.minute,
            second: otherComponents.second
        )
        return resultComponents.date
    }
}
