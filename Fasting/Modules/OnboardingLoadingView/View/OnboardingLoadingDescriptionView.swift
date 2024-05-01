//
//  OnboardingLoadingDescriptionView.swift
//  Fasting
//
//  Created by Denis Khlopin on 11.12.2023.
//

import SwiftUI

struct OnboardingLoadingDescriptionView: View {
    let description: String

    var body: some View {
        VStack(alignment: .center, spacing: Layout.emptySpacing) {
            Spacer()
            Text(description)
                .multilineTextAlignment(.center)
                .font(.poppinsBold(.headerL))
                .foregroundColor(.white)
                .padding(.horizontal, Layout.horizontalPadding)
                .frame(height: Layout.descriptionHeight, alignment: .top)
                .id(description)
                .transition(.scale.animation(.linear(duration: Layout.changeTextAnimationDuration)))
        }
    }
}

private extension OnboardingLoadingDescriptionView {
    enum Layout {
        static let emptySpacing: CGFloat = 0
        static let changeTextAnimationDuration: CGFloat = 0.2
        static let descriptionHeight: CGFloat = 320
        static let horizontalPadding: CGFloat = 44
    }
}
