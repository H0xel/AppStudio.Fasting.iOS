//
//  FoodSearchLoadingView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.08.2024.
//

import SwiftUI

struct FoodSearchLoadingView: View {
    @State private var timer = Timer.publish(every: CGFloat.timerInterval,
                                             on: .main,
                                             in: .common).autoconnect()

    @State private var rotationDegree: CGFloat = 0

    var body: some View {
        VStack(spacing: .spacing) {
            ZStack {
                Circle()
                    .stroke(Color.black.opacity(0.1),
                            style: StrokeStyle(lineWidth: .circleBorderWidth,
                                               lineCap: .square))

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.studioBlackLight,
                            style: StrokeStyle(lineWidth: .circleBorderWidth, lineCap: .square))
                    .frame(width: .circleSize, height: .circleSize, alignment: .center)
            }
            .frame(width: .circleSize, height: .circleSize, alignment: .center)
            .rotationEffect(.degrees(rotationDegree))

            Text(.loadingTitle)
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioBlackLight)
        }
        .onReceive(timer) { _ in
            rotationDegree += 3
        }
    }
}

private extension LocalizedStringKey {
    static let loadingTitle: LocalizedStringKey = "FoodSearchLoadingView.title.loading"
}

private extension CGFloat {
    static let circleSize: CGFloat = 52
    static let circleBorderWidth: CGFloat = 2
    static let spacing: CGFloat = 24
    static let titleSpacing: CGFloat = 5
    static let emojiOffset: CGFloat = -2
    static let timerInterval: CGFloat = 0.01
}

#Preview {
    FoodSearchLoadingView()
}
