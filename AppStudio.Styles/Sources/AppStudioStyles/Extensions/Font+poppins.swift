//
//  Font+poppins.swift
//
//
//  Created by Руслан Сафаргалеев on 01.03.2024.
//

import SwiftUI

public extension Font {
    static func poppins(_ font: Poppins) -> Font {
        font.isBold ? .poppinsBold(font.rawValue) : .poppins(font.rawValue)
    }

    static func adaptivePoppins(font: Poppins, smallDeviceFont: Poppins) -> Font {
        UIScreen.isSmallDevice ? .poppins(smallDeviceFont) : .poppins(font)
    }

    static func poppins(_ size: CGFloat) -> Font {
        .custom("Poppins-Regular", size: size)
    }

    static func poppinsBold(_ size: CGFloat) -> Font {
        .custom("Poppins-SemiBold", size: size)
    }

    static func poppinsBold(_ font: Poppins) -> Font {
        .custom("Poppins-SemiBold", size: font.rawValue)
    }

    static func poppinsMedium(_ font: Poppins) -> Font {
        .custom("Poppins-Medium", size: font.rawValue)
    }
}

public extension Font {
    enum Poppins: CGFloat {
        /// Size: 96
        case accentL = 96
        /// Size: 40
        case accentS = 40
        /// Size: 32
        case headerL = 32
        /// Size: 24
        case headerM = 24
        /// Size: 20
        case headerS = 20
        /// Size: 18
        case buttonText = 18
        /// Size: 15
        case body = 15
        /// Size: 13
        case description = 13

        var isBold: Bool {
            switch self {
            case .buttonText: return false
            case .body: return false
            case .description: return false
            default: return true
            }
        }
    }
}
