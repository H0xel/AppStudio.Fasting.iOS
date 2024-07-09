//  
//  QuiteModeNotificationsServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 25.06.2024.
//

import Dependencies

class QuiteModeNotificationsServiceImpl: QuiteModeNotificationsService {
    @Dependency(\.cloudStorage) private var cloudStorage

    func getAvailableIntervalsForNotifications() -> AvailableIntervalsForNotifications? {
        guard let settings = cloudStorage.notificationSettings else { return nil }

        let startDateHour = settings.quiteModeFromTime.hourIn24HoursFormat
        let endDateHour = settings.quiteModeToTime.hourIn24HoursFormat

        let startHourAndMinutes = settings.quiteModeFromTime.hourAndMinutes
        let endHourAndMinutes = settings.quiteModeToTime.hourAndMinutes

        return startDateHour > endDateHour
        ? .one(endHourAndMinutes...startHourAndMinutes)
        : .two(0...startHourAndMinutes, endHourAndMinutes...23.59)
    }
}
