//
//  Int+extensions.swift
//  
//
//  Created by Руслан Сафаргалеев on 07.03.2024.
//

import Foundation

extension Int {
    var withLeadingZeroIfOneNumber: String {
        self > 9 ? "\(self)" : "0\(self)"
    }
}
