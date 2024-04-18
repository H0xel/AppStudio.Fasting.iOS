//
//  ScrollDownButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies

struct ScrollDownButton: View {

    @Dependency(\.styles) private var styles
    let hasNewMessage: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStackWith(color: Color.white) {
                Image.chevronDown
                    .foregroundStyle(styles.colors.accent)
            }
            .frame(width: .imageWidth, height: .imageWidth)
            .continiousCornerRadius(.imageWidth / 2)
            .border(configuration: .init(
                cornerRadius: .imageWidth / 2,
                color: styles.colors.coachGreyStrokeFill,
                lineWidth: .borderWidth)
            )
            .overlay {
                if hasNewMessage {
                    Circle()
                        .fill(styles.colors.accent)
                        .frame(width: .circleWidth)
                        .overlay {
                            Text("\(1)")
                                .font(styles.fonts.description.weight(.semibold))
                                .foregroundStyle(.white)
                        }
                        .offset(y: -.circleWidth)
                }
            }
        }
    }
}

private extension CGFloat {
    static let imageWidth: CGFloat = 48
    static let borderWidth: CGFloat = 0.5
    static let circleWidth: CGFloat = 24
}

#Preview {
    ScrollDownButton(hasNewMessage: true) {}
}
