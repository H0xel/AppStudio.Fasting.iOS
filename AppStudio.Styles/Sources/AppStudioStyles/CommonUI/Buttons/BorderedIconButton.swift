//
//  BorderedIconButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioUI

public struct BorderedIconButton: View {

    var icon: Image? = nil
    let title: String?
    let action: () -> Void

    public init(icon: Image? = nil, title: String?, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Layout.spacing) {
                if let icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Layout.iconSize, height: Layout.iconSize)
                }
                if let title {
                    Text(title)
                }
            }
            .font(.poppins(.buttonText))
            .frame(height: Layout.lineHeight)
            .foregroundStyle(Color.studioBlackLight)
            .padding(.vertical, Layout.verticalPadding)
            .aligned(.centerHorizontaly)
            .continiousCornerRadius(Layout.cornerRadius)
            .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                         color: .studioGreyStrokeFill))
        }
    }
}

private extension BorderedIconButton {
    enum Layout {
        static let cornerRadius: CGFloat = 22
        static let verticalPadding: CGFloat = 18
        static let lineHeight: CGFloat = 27
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 8
    }
}

#Preview {
    BorderedIconButton(title: "CancelTitle", action: {})
}
