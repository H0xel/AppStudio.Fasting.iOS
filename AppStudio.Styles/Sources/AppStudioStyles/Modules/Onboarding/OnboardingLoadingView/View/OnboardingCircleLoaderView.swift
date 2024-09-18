//
//  OnboardingCircleLoaderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingCircleLoaderView: View {
    let progress: CGFloat
    var fillColor: Color = .white
    var circleSize: CGFloat = Layout.circleSize
    var borderWidth: CGFloat = Layout.circleBorderWidth

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1),
                        style: StrokeStyle(lineWidth: borderWidth,
                                           lineCap: .square))

            Circle()
                .trim(from: 0, to: progress)
                .stroke(fillColor, style: StrokeStyle(lineWidth: borderWidth, lineCap: .square))
                .frame(width: circleSize, height: circleSize, alignment: .center)
        }
        .frame(width: circleSize, height: circleSize, alignment: .center)
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
        OnboardingCircleLoaderView(progress: 0.3,
                                   fillColor: .black,
                                   circleSize: 52,
                                   borderWidth: 2)
    }
}
