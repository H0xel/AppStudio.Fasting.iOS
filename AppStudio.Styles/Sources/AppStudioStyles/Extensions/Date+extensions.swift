//
//  Date+extensions.swift
//
//
//  Created by Amakhin Ivan on 15.05.2024.
//

import Foundation

extension Date {
    func localizedDateOrTodayOrYesterday(with template: String = "MMMMdyyyy") -> String {
        if isSameDay(with: .now) {
            return NSLocalizedString("Today.title", bundle: .module, comment: "Today")
        }
        if isYesterday {
            return NSLocalizedString("Date.yesterday.title", bundle: .module, comment: "Yesterday")
        }
        return currentLocaleFormatted(with: template)
    }
}
