//
//  Date+extensions.swift
//
//
//  Created by Amakhin Ivan on 15.05.2024.
//

import Foundation

public extension Date {
    func localizedDateOrTodayOrYesterday(with template: String = "MMMMdyyyy") -> String {
        if isSameDay(with: .now) {
            return NSLocalizedString("Today.title", bundle: .module, comment: "Today")
        }
        if isYesterday {
            return NSLocalizedString("Date.yesterday.title", bundle: .module, comment: "Yesterday")
        }
        return currentLocaleFormatted(with: template)
    }

    static func setHour(hour: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.date(bySetting: .hour, value: hour, of: .now) ?? .now
    }

    func isPM() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate.contains("PM")
    }

    var hourIn24HoursFormat: Int {
        if self.isPM(), (self.dateComponents.hour ?? 0) < 13 {
            return (self.dateComponents.hour ?? 0) + 12
        }

        if self.dateComponents.hour == 0 {
            return 12
        }
        return self.dateComponents.hour ?? 12
    }

    var hourAndMinutes: Double {
        Double("\(hourIn24HoursFormat).\(dateComponents.minute ?? 0)") ?? 0
    }
}
