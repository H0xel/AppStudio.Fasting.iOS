//
//  OnboardingLoadingHeaderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingLoadingHeaderView: View {
    let progress: CGFloat
    let title: String
    @State private var viewHeight: CGFloat = 0

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            OnboardingCircleLoaderView(progress: progress)
                .padding(.top, viewHeight / 2 - Layout.circleHeight)

            Text(title)
                .font(.poppins(.headerS))
                .padding(.top, Layout.paddingBetweenTextAndCircle)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .withViewHeightPreferenceKey
        .onViewHeightPreferenceKeyChange { newHeight in
            viewHeight = newHeight
        }
    }
}

private extension OnboardingLoadingHeaderView {
    enum Layout {
        static let circleHeight: CGFloat = 106
        static let paddingBetweenTextAndCircle: CGFloat = 64
    }
}

struct OnboardingLoadingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            OnboardingLoadingHeaderView(progress: 0.3, title: "Stay somewhere")
        }
    }
}
