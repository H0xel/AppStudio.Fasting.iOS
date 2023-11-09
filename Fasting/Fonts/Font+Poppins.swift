//
//  Font+Poppins.swift
//  Fasting
//
//  Created by Amakhin Ivan on 27.10.2023.
//

import SwiftUI

extension Font {
    static func poppins(_ font: Poppins) -> Font {
        font.isBold ? .poppinsBold(font.rawValue) : .poppins(font.rawValue)
    }

    static func poppins(_ size: CGFloat) -> Font {
        return .custom("Poppins-Regular", size: size)
    }

    static func poppinsBold(_ size: CGFloat) -> Font {
        return .custom("Poppins-SemiBold", size: size)
    }

    static func poppinsBold(_ font: Poppins) -> Font {
        return .custom("Poppins-SemiBold", size: font.rawValue)
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
        VStack {
            Text("Accent L")
                .font(.poppins(.accentL))
            Text("Accent M")
                .font(.poppins(.accentS))
            Text("Some text")
                .font(.poppins(.body))
        }
    }
}
