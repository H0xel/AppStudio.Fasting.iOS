//
//  FastingLocalNotificationServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 14.11.2023.
//

import Foundation
import UserNotifications
import UIKit

class FastingLocalNotificationServiceImpl: FastingLocalNotificationService {
    func updateNotifications(interval: FastingInterval, isProcessing: Bool) {
        Task {
            clearNotifications()
            try await setNotifications(interval: interval,
                                       isProcessing: isProcessing)
        }
    }
}

// MARK: - private functions
extension FastingLocalNotificationServiceImpl {
    private func setNotifications(interval: FastingInterval, isProcessing: Bool) async throws {
        let notifications = isProcessing
        ? calculateActiveNotifications(with: interval)
        : calculateInactiveNotifications(with: interval)

        for notification in notifications {
            try await register(notification: notification, duration: Int(interval.plan.duration.hours))
        }
    }

    private func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func calculateActiveNotifications(with interval: FastingInterval) -> [FastingNotifications] {
        let endOfFastingDate = interval.endDate
        let startOfFasting = interval.startDate
        let beforeEndOfFastingDate = endOfFastingDate.addingTimeInterval(.hour * -1)
        let forgotToFinishFastingDate = endOfFastingDate.addingTimeInterval(.hour * 3)
        let fatBurningPhaseDate = startOfFasting.addingTimeInterval(.hour * 10)

        let beforeEndOfFastingNotifications = FastingLocalNotificationType.beforeEndOfFasting
            .getNotifications(from: beforeEndOfFastingDate)
        let endOfFastingNotifications = FastingLocalNotificationType.endOfFasting
            .getNotifications(from: endOfFastingDate)
        let forgotToFinishFastingNotifications = FastingLocalNotificationType.forgotToFinishFasting
            .getNotifications(from: forgotToFinishFastingDate, repeatCount: 3)
        let fatBurningPhaseNotifications = FastingLocalNotificationType.fatBurningPhase
            .getNotifications(from: fatBurningPhaseDate)

        return [
            beforeEndOfFastingNotifications,
            endOfFastingNotifications,
            forgotToFinishFastingNotifications,
            fatBurningPhaseNotifications
        ]
    }

    private func register(notification: FastingNotifications, duration: Int) async throws {
        var nextStartingDate = notification.startingDate
        for info in notification.infos {
            let isAutorizationGranted = try await requestAuthorization()
            guard isAutorizationGranted else {
                throw LocalNotificationError.notAutorized
            }

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: .init(year: nextStartingDate.year,
                                    month: nextStartingDate.month,
                                    day: nextStartingDate.day,
                                    hour: nextStartingDate.hour,
                                    minute: nextStartingDate.minute,
                                    second: nextStartingDate.second),
                repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: info.content(duration: duration),
                                                trigger: trigger)
            try await UNUserNotificationCenter.current().add(request)
            nextStartingDate = nextStartingDate.addingTimeInterval(.day)
        }
    }

    private func calculateInactiveNotifications(with interval: FastingInterval) -> [FastingNotifications] {
        let startOfFastingDate = interval.startDate
        let beforeStartOfFastingDate = startOfFastingDate.addingTimeInterval(.hour * -1)
        let forgotToStartFastingDate = startOfFastingDate.addingTimeInterval(.hour * 1)

        let beforeStartOfFastingNotifications = FastingLocalNotificationType.beforeStartOfFasting
            .getNotifications(from: beforeStartOfFastingDate, repeatCount: 3)
        let startOfFastingNotifications = FastingLocalNotificationType.startOfFasting
            .getNotifications(from: startOfFastingDate, repeatCount: 3)
        let forgotToStartFastingNotifications = FastingLocalNotificationType.forgotToStartFasting
            .getNotifications(from: forgotToStartFastingDate, repeatCount: 3)

        return [
            beforeStartOfFastingNotifications,
            startOfFastingNotifications,
            forgotToStartFastingNotifications
        ]
    }

    private func requestAuthorization() async throws -> Bool {
        let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        await UIApplication.shared.registerForRemoteNotifications()
        return granted
    }
}

enum LocalNotificationError: Error {
    case notAutorized
    case addRequestFail
}
