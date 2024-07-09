//
//  OnboardingPreviousPageButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

struct OnboardingPreviousPageButton: View {
    let type: ButtonType
    let onTap: () -> Void

    init(type: ButtonType = .image(.arrowLeft), onTap: @escaping () -> Void) {
        self.type = type
        self.onTap = onTap
    }

    var body: some View {

        Button(action: onTap) {
            VStack {
                switch type {
                case .image(let image):
                    image
                        .padding(Layout.padding)
                case .text(let localizedStringKey):
                    Text(localizedStringKey)
                        .padding(.horizontal, Layout.horizontalTextPadding)
                        .padding(.vertical, Layout.verticalTextPadding)
                }
            }
            .foregroundStyle(.accent)
            .font(.poppins(.buttonText))
            .background(.white)
            .continiousCornerRadius(Layout.cornerRadius)
            .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                         color: .studioGreyStrokeFill))
        }
    }
}

extension OnboardingPreviousPageButton {
    enum ButtonType {
        case image(Image)
        case text(LocalizedStringKey)
    }
}

private extension OnboardingPreviousPageButton {
    enum Layout {
        static let padding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
        static let horizontalTextPadding: CGFloat = 32
        static let verticalTextPadding: CGFloat = 18
    }
}

#Preview {
    OnboardingPreviousPageButton {}
}
