//
//  UserSenderMessageView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies

struct UserSenderMessageView: View {

    @Dependency(\.styles) private var styles

    let message: CoachMessage

    var body: some View {
        Text(message.text)
            .font(styles.fonts.body)
            .padding(.vertical, .verticalPadding)
            .padding(.horizontal, .horizontalPadding)
            .background(
                ZStack {
                    Color.white
                    styles.colors.userMessage
                }
            )
            .corners([.topLeft, .bottomLeft, .topRight],
                     with: .roundCornerRadius)
            .corners([.bottomRight], with: .cornerRadius)
            .padding(.trailing, .shortPadding)
            .padding(.leading, .longPadding)
            .aligned(.right)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 12
    static let shortPadding: CGFloat = 16
    static let longPadding: CGFloat = 64
    static let roundCornerRadius: CGFloat = 20
    static let cornerRadius: CGFloat = 2
}

#Preview {
    UserSenderMessageView(message: .mockUser())
}
