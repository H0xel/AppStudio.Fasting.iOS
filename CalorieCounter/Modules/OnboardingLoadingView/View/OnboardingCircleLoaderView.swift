//
//  OnboardingCircleLoaderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingCircleLoaderView: View {
    let progress: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1),
                        style: StrokeStyle(lineWidth: Layout.circleBorderWidth,
                                           lineCap: .square))

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: Layout.circleBorderWidth, lineCap: .square))
                .frame(width: Layout.circleSize, height: Layout.circleSize, alignment: .center)
        }
        .frame(width: Layout.circleSize, height: Layout.circleSize, alignment: .center)
        .rotationEffect(.degrees(Layout.correctedAngle))
    }
}

private extension OnboardingCircleLoaderView {
    enum Layout {
        static let circleBorderWidth: CGFloat = 4
        static let circleSize: CGFloat = 106
        static let correctedAngle: CGFloat = -90
    }
}

struct OnboardingCircleLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            OnboardingCircleLoaderView(progress: 0.3)
        }
    }
}
