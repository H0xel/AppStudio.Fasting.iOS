//
//  DoubleValuePredefinedValue.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//

import Foundation

struct DoubleValuePredefinedValue: Hashable {
    let value: Double
    let title: String

    init(value: Double, title: String? = nil) {
        self.value = value
        let title: String = title ?? "\(Int(value))"
        self.title = title
    }
}
