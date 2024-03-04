//
//  BorderedButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioUI

struct BorderedButton: View {

    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppins(.buttonText))
                .frame(height: Layout.lineHeight)
                .foregroundStyle(Color.accentColor)
                .padding(.vertical, Layout.verticalPadding)
                .aligned(.centerHorizontaly)
                .continiousCornerRadius(Layout.cornerRadius)
                .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                             color: .studioGreyStrokeFill))
        }
    }
}

private extension BorderedButton {
    enum Layout {
        static let cornerRadius: CGFloat = 22
        static let verticalPadding: CGFloat = 18
        static let lineHeight: CGFloat = 27
    }
}

#Preview {
    BorderedButton(title: "CancelTitle", action: {})
}
