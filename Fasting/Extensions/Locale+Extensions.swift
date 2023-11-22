//
//  Locale+Extensions.swift
//  Fasting
//
//  Created by Denis Khlopin on 21.11.2023.
//

import Foundation

extension Locale {
    var is24TimeFormat: Bool {
        let formatter = DateFormatter()
        formatter.locale = self
        formatter.timeStyle = .short
        guard let dateFormat = formatter.dateFormat, dateFormat.prefix(2) == "HH" else {
            return false
        }
        return true
    }

    var shortTimeFormat: String {
        is24TimeFormat ? "HH:mm" : "h:mm a"
    }

    var shortDateFormat: String {
        is24TimeFormat ? "d MMMM" : "MMMM d"
    }

    var shortDateTimeFormat: String {
        "\(shortDateFormat), \(shortTimeFormat)"
    }
}
