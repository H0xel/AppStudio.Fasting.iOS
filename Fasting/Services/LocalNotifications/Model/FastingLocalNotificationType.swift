//
//  FastingLocalNotificationType.swift
//  Fasting
//
//  Created by Denis Khlopin on 14.11.2023.
//

import Foundation

enum FastingLocalNotificationType {
    /// Conditions:
    ///  1. Fasting is Inactive
    ///  2. One hour before next fasting time
    case beforeStartOfFasting

    /// Conditions:
    ///  1. Fasting is Inactive
    ///  2. Time is next fasting time
    case startOfFasting

    /// Conditions:
    ///  1. Fasting is Active
    ///  2. One hour before end of current fasting
    case beforeEndOfFasting

    /// Conditions:
    ///  1. Fasting is Active
    ///  2. Time is end of Fasting time
    case endOfFasting

    /// Conditions:
    ///  1. Fasting is Inactive
    ///  2. One hour after next fasting time
    case forgotToStartFasting

    /// Conditions:
    ///  1. Fasting is Active
    ///  2. Three hours after fasting is finished
    case forgotToFinishFasting

    ///  1. Fasting is Active
    ///  2. fat burning phase is started
    case fatBurningPhase

    private var messages: [FastingNotificationInfo] {
        switch self {
        case .beforeStartOfFasting:
            return .beforeStartOfFastingInfos
        case .startOfFasting:
            return .startOfFastingInfos
        case .beforeEndOfFasting:
            return .beforeEndOfFastingInfos
        case .endOfFasting:
            return .endOfFastingInfos
        case .forgotToStartFasting:
            return .forgotToStartFastingInfos
        case .forgotToFinishFasting:
            return .forgotToFinishFastingInfos
        case .fatBurningPhase:
            return .fatBurningPhaseInfos
        }
    }

    func getNotifications(from date: Date, repeatCount: Int = 1) -> FastingNotifications {
        let messages = messages
        var repeatCount = repeatCount
        var infos = [FastingNotificationInfo]()
        while repeatCount > 0 {
            let index = Int.random(in: 0..<messages.count)
            infos.append(messages[index])
            repeatCount -= 1
        }
        return FastingNotifications(infos: infos, startingDate: date)
    }
}
