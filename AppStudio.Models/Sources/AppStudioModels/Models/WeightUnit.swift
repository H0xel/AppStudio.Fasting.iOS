//
//  WeightUnit.swift
//  
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation

// swiftlint:disable identifier_name
public enum WeightUnit: String, Codable, CaseIterable {
    case lb
    case kg

    public var title: String {
        "WeightUnit.\(rawValue)".localized(bundle: .module)
    }

    public static func convertToKg(lbsValue: CGFloat) -> CGFloat {
        lbsValue / 2.205
    }

    public static func convertToLbs(kgValue: CGFloat) -> CGFloat {
        kgValue * 2.205
    }
}
// swiftlint:enable identifier_name
