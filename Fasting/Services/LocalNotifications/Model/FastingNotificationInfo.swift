//
//  FastingNotificationInfo.swift
//  Fasting
//
//  Created by Denis Khlopin on 14.11.2023.
//

import Foundation
import UserNotifications

struct FastingNotificationInfo {
    let id: String
    let title: String
    let subTitle: String

    init(id: String) {
        self.id = id
        self.title = NSLocalizedString("\(id).title", comment: "title")
        self.subTitle = NSLocalizedString("\(id).subtitle", comment: "title")
    }

    init(title: String, subTitle: String) {
        self.id = UUID().uuidString
        self.title = title
        self.subTitle = subTitle
    }
}

extension FastingNotificationInfo {
    func content(duration: Int) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = String(format: title, duration)
        content.body = String(format: subTitle, duration)
        content.sound = UNNotificationSound.default
        return content
    }
}

extension Array where Element == FastingNotificationInfo {
    static func beforeStartOfFastingInfos(timePushDescription: String) -> [FastingNotificationInfo] {
        [
            .init(
                title: "NotificationType.beforeStartOfFasting1.title".localized(),
                subTitle: String(format: "NotificationType.beforeStartOfFasting1.subtitle".localized(),
                                 timePushDescription)
            ),
            .init(
                title: "NotificationType.beforeStartOfFasting2.title".localized(),
                subTitle: String(format: "NotificationType.beforeStartOfFasting2.subtitle".localized(),
                                 timePushDescription)
            ),
            .init(
                title: String(format: "NotificationType.beforeStartOfFasting3.title".localized(),
                              timePushDescription
                ),
                subTitle: String(format: "NotificationType.beforeStartOfFasting3.subtitle".localized(),
                                 timePushDescription)
            )
        ]
    }
    static let startOfFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.startOfFasting1"),
          .init(id: "NotificationType.startOfFasting2"),
          .init(id: "NotificationType.startOfFasting3") ]
    }()

    static func beforeEndOfFastingInfos(
        notificationPrior: NotificationPrior,
        fastingDuration: Int
    ) -> [FastingNotificationInfo] {
        [
//            .init(
//                title: "NotificationType.beforeEndOfFasting1.title".localized(),
//                subTitle: String(format: "NotificationType.beforeEndOfFasting1.subtitle".localized(),
//                                 notificationPrior.pushDescription)
//            ),
            .init(
                title: notificationPrior.pushTitle,
                subTitle: String(format: "NotificationType.beforeEndOfFasting2.subtitle".localized(),
                                 notificationPrior.pushDescription, fastingDuration)
            )
//            .init(
//                title: "NotificationType.beforeEndOfFasting3.title".localized(),
//                subTitle: String(format: "NotificationType.beforeEndOfFasting3.subtitle".localized(),
//                                 notificationPrior.pushTitle.lowercased())
//            )
        ]
    }
    static let endOfFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.endOfFasting1"),
          .init(id: "NotificationType.endOfFasting2"),
          .init(id: "NotificationType.endOfFasting3") ]
    }()
    static let forgotToStartFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.forgotToStartFasting") ]
    }()
    static let forgotToFinishFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.forgotToFinishFasting") ]
    }()
    static let fatBurningPhaseInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.fatBurningPhaseInfos") ]
    }()
    static let sugarRisesPhaseInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.sugarRisesPhaseInfos") ]
    }()
    static let sugarDropPhaseInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.sugarDropPhaseInfos") ]
    }()
    static let sugarNormalPhaseInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.sugarNormalPhaseInfos") ]
    }()
    static let ketosisPhaseInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.ketosisPhaseInfos") ]
    }()
    static let autophagyPhaseInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.autophagyPhaseInfos") ]
    }()
}

// Hydration Reminders

extension FastingNotificationInfo {
    static var hydrationReminders: FastingNotificationInfo {
        .init(title: "NotificationType.hydrationReminders.title".localized(),
              subTitle: "NotificationType.hydrationReminders.\(Int.random(range: 1...8)).subtitle".localized())
    }

    static var weightInReminder: FastingNotificationInfo {
        .init(id: "NotificationType.weightInReminder")
    }
}


extension Int {
    static func random(range: ClosedRange<Int>) -> Int {
        let randomValue = random(in: range)

        if randomValue != lastRandomValue {
            lastRandomValue = randomValue
            return randomValue
        }

        return random(in: range)
    }

    static private var lastRandomValue: Int = 0
}
