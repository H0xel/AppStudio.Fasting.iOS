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
    static let beforeStartOfFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.beforeStartOfFasting1"),
          .init(id: "NotificationType.beforeStartOfFasting2"),
          .init(id: "NotificationType.beforeStartOfFasting3") ]
    }()
    static let startOfFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.startOfFasting1"),
          .init(id: "NotificationType.startOfFasting2"),
          .init(id: "NotificationType.startOfFasting3") ]
    }()
    static let beforeEndOfFastingInfos: [FastingNotificationInfo] = {
        [ .init(id: "NotificationType.beforeEndOfFasting1"),
          .init(id: "NotificationType.beforeEndOfFasting2"),
          .init(id: "NotificationType.beforeEndOfFasting3") ]
    }()
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
}
