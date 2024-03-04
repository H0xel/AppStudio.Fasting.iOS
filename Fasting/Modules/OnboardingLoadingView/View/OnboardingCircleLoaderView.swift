//
//  OnboardingCircleLoaderView.swift
//  Fasting
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingCircleLoaderView: View {
    let progress: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.studioGrayFillProgress,
                        style: StrokeStyle(lineWidth: Layout.circleBorderWidth,
                                           lineCap: .square))

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.black, style: StrokeStyle(lineWidth: Layout.circleBorderWidth, lineCap: .square))
                .frame(width: Layout.circleSize, height: Layout.circleSize, alignment: .center)
        }
        .frame(width: Layout.circleSize, height: Layout.circleSize, alignment: .center)
        .rotationEffect(.degrees(Layout.correctedAngle))
    }
}

private extension OnboardingCircleLoaderView {
    enum Layout {
        static let circleBorderWidth: CGFloat = 2
        static let circleSize: CGFloat = 52
        static let correctedAngle: CGFloat = -90
    }
}
