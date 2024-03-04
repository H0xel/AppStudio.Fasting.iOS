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
                .padding(.horizontal, Layout.horizontalPadding)
                .frame(height: Layout.buttonHeight)
                .background(color)
                .continiousCornerRadius(Layout.cornerRadius)
                .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                             color: .white))
        }
    }
}

#Preview {
    SetupFastingButton(title: "Change", color: .studioBlue) {}
}

private extension SetupFastingButton {
    enum Layout {
        static let cornerRadius: CGFloat = 44
        static let verticalPadding: CGFloat = 13
        static let horizontalPadding: CGFloat = 24
        static let buttonHeight: CGFloat = 44
    }
}
