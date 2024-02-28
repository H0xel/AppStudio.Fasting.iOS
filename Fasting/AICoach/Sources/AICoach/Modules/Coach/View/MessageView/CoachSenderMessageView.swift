//
//  CoachSenderMessageView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import MunicornUtilities
import Dependencies

struct CoachSenderMessageView: View {

    let message: CoachMessage
    @Dependency(\.styles) private var styles

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            ForEach(messages, id: \.self) { message in
                Text(message)
                    .foregroundStyle(styles.colors.accent)
                    .font(styles.fonts.body)
                    .padding(.vertical, .verticalPadding)
                    .padding(.horizontal, .horizontalPadding)
                    .background(.white)
                    .corners([.bottomLeft, .bottomRight, .topRight],
                             with: .roundCornerRadius)
                    .corners(
                        [.topLeft],
                        with: message == messages.first ? .cornerRadius : .roundCornerRadius
                    )
                    .modifier(CoachMessageLeftAlignedModifier())
            }
        }
    }

    private var messages: [String] {
        message.text
            .components(separatedBy: "||").map { $0.trimmingCharacters(in: ["\n", " "]) }
            .filter { !$0.isEmpty }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 12
    static let roundCornerRadius: CGFloat = 20
    static let cornerRadius: CGFloat = 2
}

#Preview {
    ZStack {
        VStack {
            CoachSenderMessageView(message: .mockCoach())
            CoachSenderMessageView(message: .mockCoachLong())
            CoachSenderMessageView(message: .mockCoachShort())
        }
    }
}
