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
    case beforeStartOfFasting(beforeTime: String)

    /// Conditions:
    ///  1. Fasting is Inactive
    ///  2. Time is next fasting time
    case startOfFasting

    /// Conditions:
    ///  1. Fasting is Active
    ///  2. One hour before end of current fasting
    case beforeEndOfFasting(prior: NotificationPrior, fastingDuration: Int)

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
    ///  2. sugar rises phase is started
    case sugarRisesPhase

    ///  1. Fasting is Active
    ///  2. sugar drop phase is started
    case sugarDropPhase

    ///  1. Fasting is Active
    ///  2. sugar normal phase is started
    case sugarNormalPhase

    ///  1. Fasting is Active
    ///  2. fat burning phase is started
    case fatBurningPhase

    ///  1. Fasting is Active
    ///  2.ketosis phase is started
    case ketosisPhase

    ///  1. Fasting is Active
    ///  2. autophagy phase is started
    case autophagyPhase

    private var messages: [FastingNotificationInfo] {
        switch self {
        case let .beforeStartOfFasting(time):
            return .beforeStartOfFastingInfos(timePushDescription: time)
        case .startOfFasting:
            return .startOfFastingInfos
        case let .beforeEndOfFasting(prior, fastingDuration):
            return .beforeEndOfFastingInfos(notificationPrior: prior, fastingDuration: fastingDuration)
        case .endOfFasting:
            return .endOfFastingInfos
        case .forgotToStartFasting:
            return .forgotToStartFastingInfos
        case .forgotToFinishFasting:
            return .forgotToFinishFastingInfos
        case .fatBurningPhase:
            return .fatBurningPhaseInfos
        case .sugarRisesPhase:
            return .sugarRisesPhaseInfos
        case .sugarDropPhase:
            return .sugarDropPhaseInfos
        case .sugarNormalPhase:
            return .sugarNormalPhaseInfos
        case .ketosisPhase:
            return .ketosisPhaseInfos
        case .autophagyPhase:
            return .autophagyPhaseInfos
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
