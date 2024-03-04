//
//  HeightUnit.swift
//  CalorieCounter
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

    static func convertToCm(ftValue: CGFloat) -> CGFloat {
        ftValue / 0.0328084
    }

    static func convertToFt(cmValue: CGFloat) -> CGFloat {
        cmValue * 0.0328084
    }
}
// swiftlint:enable identifier_name
