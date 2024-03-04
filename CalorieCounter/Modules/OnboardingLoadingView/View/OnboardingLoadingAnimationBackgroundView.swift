//
//  OnboardingLoadingAnimationBackgroundView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingLoadingAnimationBackgroundView: View {
    let angle: CGFloat
    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
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
        UIScreen.isSmallDevice ? 1800 : 2000
    }

    private var bottomImagePadding: CGFloat {
        UIScreen.isSmallDevice ? 150 : 300
    }
}

struct OnboardingLoadingAnimationBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            OnboardingLoadingAnimationBackgroundView(angle: 0.3)
        }
    }
}
