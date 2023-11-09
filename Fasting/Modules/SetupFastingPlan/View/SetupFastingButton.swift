//
//  SetupFastingButton.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioUI

struct SetupFastingButton: View {
    let title: LocalizedStringKey
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(.white)
                .padding(.vertical, Layout.verticalPadding)
                .padding(.horizontal, Layout.horizontalPadding)
                .aligned(.centerHorizontaly)
                .background(color)
                .continiousCornerRadius(Layout.cornerRadius)
                .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                             color: .white))
        }
        .frame(width: Layout.buttonWidth, height: Layout.buttonHeight)
    }
}

#Preview {
    SetupFastingButton(title: "Change", color: .fastingBlue) {}
}

private extension SetupFastingButton {
    enum Layout {
        static let cornerRadius: CGFloat = 44
        static let verticalPadding: CGFloat = 18
        static let horizontalPadding: CGFloat = 24
        static let buttonWidth: CGFloat = 117
        static let buttonHeight: CGFloat = 44
    }
}
