//
//  StartFastingButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioUI

struct AccentButton: View {

    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppins(.buttonText))
                .frame(height: Layout.lineHeight)
                .foregroundStyle(.white)
                .padding(.vertical, Layout.verticalPadding)
                .aligned(.centerHorizontaly)
                .background(Color.accentColor)
                .continiousCornerRadius(Layout.cornerRadius)
        }
    }
}

private extension AccentButton {
    enum Layout {
        static let cornerRadius: CGFloat = 22
        static let verticalPadding: CGFloat = 18
        static let lineHeight: CGFloat = 27
    }
}

#Preview {
    AccentButton(title: "FastingScreen.startFasting", action: {})
}
