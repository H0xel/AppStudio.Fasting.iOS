//  
//  NotificationSettingsServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 19.06.2024.
//

import Dependencies
import Foundation
import UserNotifications

class NotificationSettingsServiceImpl: NotificationSettingsService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.quiteModeNotificationsService) private var quiteModeNotificationsService
    @Published private var hasSubscription = false

    init() {
        initialize()
    }

    func registerNotifications() {
        guard let settings = cloudStorage.notificationSettings,
              let interval = quiteModeNotificationsService.getAvailableIntervalsForNotifications() else { return }

        if settings.isWeightToggled, hasSubscription {
            registerWeightNotifications(settings: settings, interval: interval)
        }

        if settings.isHydrationToggled, hasSubscription {
            registerHydrationNotifications(settings: settings, interval: interval)
        }
    }
}


private extension NotificationSettingsServiceImpl {

    private func registerNotification(
        id: String,
        info: FastingNotificationInfo,
        components: DateComponents,
        isRepeatable: Bool
    ) async {
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: isRepeatable
        )

        let request = UNNotificationRequest(identifier: id,
                                            content: info.content(duration: 0),
                                            trigger: trigger)
        Task {
            try await UNUserNotificationCenter.current().add(request)
        }
    }

    func registerWeightNotifications(settings: NotificationSettings, interval: AvailableIntervalsForNotifications) {
        Task.detached(priority: .background) { [weak self] in
            let dayUpdateFrequency = settings.weightFrequency.days
            let initialIntervalTime = settings.timeToWeight.hourAndMinutes

            guard let self, self.shouldRegisterNotification(
                settings: settings,
                at: initialIntervalTime,
                for: interval) else {
                return
            }

            if dayUpdateFrequency == 1 {
                await self.registerNotification(
                    id: UUID().uuidString,
                    info: .weightInReminder,
                    components: .init(
                        hour: initialIntervalTime
                            .getIntegerAndFractionalPartsAsInt(fractionalMultiplier: 100)
                            .integerPart,
                        minute: initialIntervalTime
                            .getIntegerAndFractionalPartsAsInt(fractionalMultiplier: 100)
                            .fractionalPart
                    ),
                    isRepeatable: true
                )
                return
            }
            for _ in stride(from: 0, to: 30, by: dayUpdateFrequency) {
                await self.registerNotification(
                    id: UUID().uuidString,
                    info: .weightInReminder,
                    components: .init(
                        hour: initialIntervalTime
                            .getIntegerAndFractionalPartsAsInt(fractionalMultiplier: 100)
                            .integerPart,
                        minute: initialIntervalTime
                            .getIntegerAndFractionalPartsAsInt(fractionalMultiplier: 100)
                            .fractionalPart
                    ),
                    isRepeatable: false
                )
            }
        }
    }

    func registerHydrationNotifications(settings: NotificationSettings, interval: AvailableIntervalsForNotifications) {
        Task.detached(priority: .background) { [weak self] in
            guard let self else { return}
            var initialIntervalTime = settings.startTimeHydration.hourAndMinutes
            while initialIntervalTime < settings.endTimeHydration.hourAndMinutes {
                if self.shouldRegisterNotification(
                    settings: settings,
                    at: initialIntervalTime,
                    for: interval
                ) {
                    await self.registerNotification(
                        id: initialIntervalTime.description,
                        info: .hydrationReminders,
                        components: .init(
                            hour: initialIntervalTime
                                .getIntegerAndFractionalPartsAsInt(fractionalMultiplier: 100)
                                .integerPart,
                            minute: initialIntervalTime
                                .getIntegerAndFractionalPartsAsInt(fractionalMultiplier: 100)
                                .fractionalPart
                        ),
                        isRepeatable: true
                    )
                }
                initialIntervalTime += Double(settings.hydrationFrequency.hours)
            }
        }
    }

    func shouldRegisterNotification(
        settings: NotificationSettings,
        at time: Double,
        for interval: AvailableIntervalsForNotifications
    ) -> Bool {
        guard settings.isQuietModeToggled else { return true }
        switch interval {
        case .one(let availableDayInterval):
            return availableDayInterval.contains(time)
        case let .two(availableFirstDayInterval, availableSecondDayInterval):
            return availableFirstDayInterval.contains(time) || availableSecondDayInterval.contains(time)
        }
    }

    func initialize() {
        newSubscriptionService.hasSubscription
            .assign(to: &$hasSubscription)
    }
}
