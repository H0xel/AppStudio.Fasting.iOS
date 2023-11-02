//
//  Int+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import Foundation

extension Int {
    var withLeadingZeroIfOneNumber: String {
        self > 9 ? "\(self)" : "0\(self)"
    }
}
