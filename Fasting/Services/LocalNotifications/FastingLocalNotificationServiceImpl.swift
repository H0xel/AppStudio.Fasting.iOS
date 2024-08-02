//
//  FastingLocalNotificationServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 14.11.2023.
//

import Foundation
import UserNotifications
import UIKit
import Dependencies

class FastingLocalNotificationServiceImpl: FastingLocalNotificationService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.quiteModeNotificationsService) private var quiteModeNotificationsService
    @Dependency(\.notificationSettingsService) private var notificationSettingsService
    @Published private var hasSubscription = false

    init() {
        newSubscriptionService.hasSubscription.assign(to: &$hasSubscription)
    }

    func updateNotifications(interval: FastingInterval, isProcessing: Bool) {
        guard let availableForNotificationsInterval = quiteModeNotificationsService
            .getAvailableIntervalsForNotifications() else {
            return
        }

        Task {
            clearNotifications()
            try await setNotifications(interval: interval,
                                       isProcessing: isProcessing,
                                       availableInterval: availableForNotificationsInterval
            )
        }
    }
}

// MARK: - private functions
extension FastingLocalNotificationServiceImpl {
    private func setNotifications(interval: FastingInterval,
                                  isProcessing: Bool,
                                  availableInterval: AvailableIntervalsForNotifications
    ) async throws {
        let notifications = isProcessing
        ? calculateActiveNotifications(with: interval, availableInterval: availableInterval)
        : calculateInactiveNotifications(with: interval, availableInterval: availableInterval)

        if isProcessing {
            let stagesNotifications = registerFastingStages(with: interval, availableInterval: availableInterval)
            for notification in stagesNotifications {
                try await register(notification: notification, duration: Int(interval.plan.duration.hours))
            }
        }

        for notification in notifications {
            try await register(notification: notification, duration: Int(interval.plan.duration.hours))
        }

        notificationSettingsService.registerNotifications()
    }

    private func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func calculateActiveNotifications(
        with interval: FastingInterval,
        availableInterval: AvailableIntervalsForNotifications
    ) -> [FastingNotifications] {
        guard let settings = cloudStorage.notificationSettings else { return [] }

        let endOfFastingDate = interval.endDate
        let beforeEndOfFastingDate = endOfFastingDate.addingTimeInterval(.hour * -1)
        let forgotToFinishFastingDate = endOfFastingDate.addingTimeInterval(.hour * 3)

        var notifications: [FastingNotifications] = []

        if settings.advanceRemindersToggled,
            let beforeEndOfFastingNotifications = tryToRegisterNotification(
                stageDate: beforeEndOfFastingDate,
                type: .beforeEndOfFasting(prior: settings.beforeEndPriorSelection,
                                          fastingDuration: Int(interval.plan.duration.hours)),
                availableInterval: availableInterval) {
            notifications.append(beforeEndOfFastingNotifications)
        }

        if settings.endToFastToggled,
           let endOfFastingNotifications = tryToRegisterNotification(
            stageDate: endOfFastingDate,
            type: .endOfFasting,
            availableInterval: availableInterval) {
            notifications.append(endOfFastingNotifications)
        }

        if let forgotToFinishFastingNotifications = tryToRegisterNotification(
            stageDate: forgotToFinishFastingDate,
            type: .forgotToFinishFasting,
            availableInterval: availableInterval,
            repeatCount: 3) {
            notifications.append(forgotToFinishFastingNotifications)
        }

        return notifications
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

    private func registerFastingStages(
        with interval: FastingInterval,
        availableInterval: AvailableIntervalsForNotifications
    ) -> [FastingNotifications] {
        guard let settings = cloudStorage.notificationSettings, hasSubscription else { return [] }

        let startOfFasting = interval.startDate

        let sugarRisesPhaseDate = startOfFasting.addingTimeInterval(.minute * 1)

        let sugarDropPhaseDate = startOfFasting.addingTimeInterval(.hour * 2)

        let sugarNormalPhaseDate = startOfFasting.addingTimeInterval(.hour * 8)

        let fatBurningPhaseDate = startOfFasting.addingTimeInterval(.hour * 10)

        let ketosisPhaseDate = startOfFasting.addingTimeInterval(.hour * 14)

        let autophagyPhaseDate = startOfFasting.addingTimeInterval(.hour * 16)

        var notifications: [FastingNotifications] = []

        if settings.selectedFastingStages.contains(.sugarRises),
           let sugarRisesStage = tryToRegisterNotification(stageDate: sugarRisesPhaseDate,
                                                           type: .sugarRisesPhase,
                                                           availableInterval: availableInterval) {
            notifications.append(sugarRisesStage)
        }

        if settings.selectedFastingStages.contains(.sugarDrop),
           let sugarDropStage = tryToRegisterNotification(stageDate: sugarDropPhaseDate,
                                                          type: .sugarDropPhase,
                                                          availableInterval: availableInterval) {
            notifications.append(sugarDropStage)
        }


        if settings.selectedFastingStages.contains(.sugarNormal),
           let sugarNormalStage = tryToRegisterNotification(stageDate: sugarNormalPhaseDate,
                                                            type: .sugarNormalPhase,
                                                            availableInterval: availableInterval) {
            notifications.append(sugarNormalStage)
        }

        if settings.selectedFastingStages.contains(.burning),
           let burningStage = tryToRegisterNotification(stageDate: fatBurningPhaseDate,
                                                        type: .fatBurningPhase,
                                                        availableInterval: availableInterval) {
            notifications.append(burningStage)
        }

        if settings.selectedFastingStages.contains(.ketosis),
           let ketosisStage = tryToRegisterNotification(stageDate: ketosisPhaseDate,
                                                        type: .ketosisPhase,
                                                        availableInterval: availableInterval) {
            notifications.append(ketosisStage)
        }

        if settings.selectedFastingStages.contains(.autophagy),
           let autographyStage = tryToRegisterNotification(stageDate: autophagyPhaseDate,
                                                           type: .autophagyPhase,
                                                           availableInterval: availableInterval) {
            notifications.append(autographyStage)
        }

        return notifications
    }

    private func calculateInactiveNotifications(
        with interval: FastingInterval,
        availableInterval: AvailableIntervalsForNotifications
    ) -> [FastingNotifications] {
        guard let settings = cloudStorage.notificationSettings else { return [] }

        let minutesBefore = settings.beforeStartPriorSelection.minutes
        let startOfFastingDate = interval.startDate
        let beforeStartOfFastingDate = startOfFastingDate.addingTimeInterval(.minute * -Double(minutesBefore))
        let forgotToStartFastingDate = startOfFastingDate.addingTimeInterval(.hour * 1)

        var notifications: [FastingNotifications] = []

        if settings.advanceRemindersToggled,
            let beforeStartOfFastingNotifications = tryToRegisterNotification(
                stageDate: beforeStartOfFastingDate,
                type: .beforeStartOfFasting(beforeTime: settings.beforeStartPriorSelection.pushDescription),
                availableInterval: availableInterval,
                repeatCount: 3) {
            notifications.append(beforeStartOfFastingNotifications)
        }

        if settings.startToFastToggled,
           let startOfFastingNotification = tryToRegisterNotification(
               stageDate: startOfFastingDate,
               type: .startOfFasting,
               availableInterval: availableInterval,
               repeatCount: 3) {
            notifications.append(startOfFastingNotification)
        }

        if let forgotToFinishFastingNotifications = tryToRegisterNotification(
            stageDate: forgotToStartFastingDate,
            type: .forgotToStartFasting,
            availableInterval: availableInterval,
            repeatCount: 3) {
            notifications.append(forgotToFinishFastingNotifications)
        }

        return notifications
    }

    private func requestAuthorization() async throws -> Bool {
        let granted = try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        await UIApplication.shared.registerForRemoteNotifications()
        return granted
    }

    private func tryToRegisterNotification(
        stageDate: Date,
        type: FastingLocalNotificationType,
        availableInterval: AvailableIntervalsForNotifications,
        repeatCount: Int = 1
    ) -> FastingNotifications? {
        guard let settings = cloudStorage.notificationSettings, hasSubscription else { return nil }
        let notification = type
            .getNotifications(from: stageDate, repeatCount: repeatCount)
        if !settings.isQuietModeToggled {
            return notification
        }

        switch availableInterval {
        case .one(let closedRange):
            if closedRange.contains(stageDate.hourAndMinutes) {
                return notification
            }
        case let .two(closedRange, closedRange2):
            if closedRange.contains(stageDate.hourAndMinutes) || closedRange2.contains(stageDate.hourAndMinutes) {
                return notification
            }
        }
        return nil
    }
}

enum LocalNotificationError: Error {
    case notAutorized
    case addRequestFail
}
