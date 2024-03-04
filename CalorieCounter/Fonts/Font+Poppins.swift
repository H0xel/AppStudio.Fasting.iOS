//
//  Font+Poppins.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI

extension Font {
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
}

extension Font {
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


struct PoppinsFont_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            Text("AccentL")
                .font(.poppins(.accentL))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Accent S")
                .font(.poppins(.accentS))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Header L")
                .font(.poppins(.headerL))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Header M")
                .font(.poppins(.headerM))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Header S")
                .font(.poppins(.headerS))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Button text")
                .font(.poppins(.headerS))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Body")
                .font(.poppins(.body))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
            Text("Description")
                .font(.poppins(.description))
                .border(configuration: .init(cornerRadius: 0, color: Color.red))
        }
    }
}
