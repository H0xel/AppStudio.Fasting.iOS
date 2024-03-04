//
//  WeightUnit.swift
//  CalorieCounter
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

    static func convertToKg(lbsValue: CGFloat) -> CGFloat {
        lbsValue / 2.205
    }

    static func convertToLbs(kgValue: CGFloat) -> CGFloat {
        kgValue * 2.205
    }
}
// swiftlint:enable identifier_name
