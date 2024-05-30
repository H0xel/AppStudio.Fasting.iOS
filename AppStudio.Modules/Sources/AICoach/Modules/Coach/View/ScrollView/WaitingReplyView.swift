//
//  WaitingReplyView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI
import Dependencies

struct WaitingReplyView: View {

    @Dependency(\.styles) private var styles

    private let timer = Timer.publish(every: 0.4, on: .main, in: .default).autoconnect()
    @State private var dotsCount = 1

    var body: some View {
        HStack(spacing: .spacing) {
            ForEach(1 ..< 4) { num in
                Circle()
                    .fill(styles.colors.coachGreyStrokeFill)
                    .frame(width: .circleWidth)
                    .opacity(num <= dotsCount ? 1 : 0)
            }
        }
        .padding(.horizontal, .horizontalPadding)
        .frame(height: .height)
        .background(.white)
        .corners([.bottomLeft, .bottomRight, .topRight],
                 with: .roundedCornerRadius)
        .corners(.topLeft, with: .cornerRadius)
        .onReceive(timer) { _ in
            dotsCount = dotsCount == 3 ? 1 : dotsCount + 1
        }
        .animation(.bouncy, value: dotsCount)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let height: CGFloat = 48
    static let circleWidth: CGFloat = 6
    static let roundedCornerRadius: CGFloat = 20
    static let cornerRadius: CGFloat = 2
    static let spacing: CGFloat = 4
}

#Preview {
    ZStack {
        Color.blue
        WaitingReplyView()
    }
}
