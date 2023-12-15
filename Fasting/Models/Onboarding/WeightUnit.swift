//
//  WeightUnit.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation
// swiftlint:disable identifier_name
enum WeightUnit: String, Codable, CaseIterable {
    case lb
    case kg

    var title: String {
        NSLocalizedString("WeightUnit.\(rawValue)", comment: "")
    }
}
// swiftlint:enable identifier_name
