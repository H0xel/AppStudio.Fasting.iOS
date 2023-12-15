//
//  OnboardingPreviousPageButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

struct OnboardingPreviousPageButton: View {

    let onTap: () -> Void

    var body: some View {

        Button(action: onTap) {
            Image.arrowLeft
                .foregroundStyle(.accent)
                .font(.poppins(.buttonText))
                .padding(Layout.padding)
                .background(.white)
                .continiousCornerRadius(Layout.cornerRadius)
                .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                             color: .fastingGreyStrokeFill))
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
