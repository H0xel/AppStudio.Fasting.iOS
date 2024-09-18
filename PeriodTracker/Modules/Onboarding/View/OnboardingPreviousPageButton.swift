//
//  OnboardingPreviousPageButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI
import AppStudioStyles

struct OnboardingPreviousPageButton: View {

    let onTap: () -> Void

    var body: some View {

        Button(action: onTap) {
            Image.arrowLeft
                .foregroundStyle(Color.studioBlackLight)
                .font(.poppins(.buttonText))
                .padding(Layout.padding)
                .background(.white)
                .continiousCornerRadius(Layout.cornerRadius)
                .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                             color: .studioGreyStrokeFill))
        }
    }
}

private extension OnboardingPreviousPageButton {
    enum Layout {
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
    }
}

#Preview {
    OnboardingPreviousPageButton {}
}
