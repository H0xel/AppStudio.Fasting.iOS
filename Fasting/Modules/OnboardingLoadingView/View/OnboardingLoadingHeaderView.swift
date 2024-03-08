//
//  OnboardingLoadingHeaderView.swift
//  Fasting
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingLoadingHeaderView: View {
    let progress: CGFloat
    let title: String

    var body: some View {
        VStack(alignment: .center, spacing: Layout.emptySpacing) {
            OnboardingCircleLoaderView(progress: progress)
                .padding(.top, Layout.paddingTop)
            Text(title)
                .font(.poppins(.buttonText))
                .padding(.top, Layout.paddingBetweenTextAndCircle)
            Spacer()
        }
    }
}

private extension OnboardingLoadingHeaderView {
    enum Layout {
        static let emptySpacing: CGFloat = 0
        static let paddingTop: CGFloat = 62
        static let paddingBetweenTextAndCircle: CGFloat = 32
    }
}
