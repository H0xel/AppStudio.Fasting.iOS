//
//  Date+LocaleTime.swift
//  Fasting
//
//  Created by Amakhin Ivan on 08.11.2023.
//

import Foundation

extension Date {
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }

    var localeTimeString: String {
        dateFormatter.string(from: self)
    }
}