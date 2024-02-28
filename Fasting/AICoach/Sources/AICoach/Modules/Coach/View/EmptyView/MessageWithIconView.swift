//
//  MessageWithIconView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI
import Dependencies

struct MessageWithIconView: View {

    @Dependency(\.styles) private var styles

    let emoji: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: .spacing) {
            Text(emoji)
                .font(.title3)
                .frame(width: .iconWidth, height: .iconWidth)
                .background(styles.colors.coachGrayFillCard)
                .continiousCornerRadius(.iconCornerRadius)
            Text(text)
                .foregroundStyle(styles.colors.accent)
                .font(styles.fonts.body)
        }
        .padding(.vertical, .verticalPadding)
        .padding(.horizontal, .horizontalPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
        .modifier(CoachMessageLeftAlignedModifier())
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    static let spacing: CGFloat = 12
    static let iconWidth: CGFloat = 44
    static let iconCornerRadius: CGFloat = 8
}

#Preview {
    ZStack {
        Color.red
        MessageWithIconView(emoji: "🙅", text: "CoachScreen.messageWithIconText.first")
    }
}
