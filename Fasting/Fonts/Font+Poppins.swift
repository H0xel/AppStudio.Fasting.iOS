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
}

extension Font {
    enum Poppins: CGFloat {
        case accentL = 96
        case accentM = 40
        case headerL = 32
        case headerM = 24
        case headerS = 20
        case buttonText = 18
        case body = 15
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
                .font(.poppins(.accentM))
            Text("Some text")
                .font(.poppins(.body))
        }
    }
}
