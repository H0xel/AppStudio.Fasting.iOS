//
//  OnboardingLoadingAnimationBackgroundView.swift
//  Fasting
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingLoadingAnimationBackgroundView: View {
    let angle: CGFloat
    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            VStack {
                Image.rainbow
                    .resizable()
                    .frame(width: rainbowSize, height: rainbowSize)
                    .position(x: screenWidth / 2, y: rainbowSize / 2)
                    .rotationEffect(.degrees(angle), anchor: .bottom)
            }
            .frame(height: rainbowSize / 2)
            .padding(.bottom, bottomImagePadding)
        }
    }

    private var rainbowSize: CGFloat {
        UIScreen.isSmallDevice ? 1100 : 1200
    }

    private var bottomImagePadding: CGFloat {
        UIScreen.isSmallDevice ? 0 : 32
    }
}
