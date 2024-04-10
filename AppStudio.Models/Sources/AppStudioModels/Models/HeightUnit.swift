//
//  HeightUnit.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import Foundation
// swiftlint:disable identifier_name
public enum HeightUnit: String, Codable, CaseIterable {
    case ft
    case cm

    public var title: String {
        "HeightUnit.\(rawValue)".localized(bundle: .module)
    }

    public static func convertToCm(ftValue: CGFloat) -> CGFloat {
        ftValue / 0.0328084
    }

    public static func convertToFt(cmValue: CGFloat) -> CGFloat {
        cmValue * 0.0328084
    }
}
// swiftlint:enable identifier_name
