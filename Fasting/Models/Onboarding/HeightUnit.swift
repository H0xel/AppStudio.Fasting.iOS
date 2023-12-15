//
//  HeightUnit.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation
// swiftlint:disable identifier_name
enum HeightUnit: String, Codable, CaseIterable {
    case ft
    case cm

    var title: String {
        NSLocalizedString("HeightUnit.\(rawValue)", comment: "")
    }
}
// swiftlint:enable identifier_name
