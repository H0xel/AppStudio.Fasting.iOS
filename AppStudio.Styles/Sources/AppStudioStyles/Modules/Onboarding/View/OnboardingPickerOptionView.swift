//
//  OnboardingPickerOptionView.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI

struct OnboardingPickerOptionView: View {

    let text: String
    let description: String?
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Layout.spacing) {
                Text(text)
                    .foregroundStyle(Color.studioBlackLight)
                    .font(.poppins(.body))
                    .aligned(.left)
                if let description {
                    Text(description)
                        .font(.poppins(.body))
                        .foregroundStyle(Color.studioGrayText)
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(.white)
            .continiousCornerRadius(Layout.cornerRadius)
            .border(configuration: .init(
                cornerRadius: Layout.cornerRadius,
                color: isSelected ? .studioBlackLight : .studioGreyStrokeFill,
                lineWidth: isSelected ? Layout.borderWidthSelected : Layout.borderWidthUnSelected)
            )
        }
    }
}

private extension OnboardingPickerOptionView {
    enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
        static let borderWidthSelected: CGFloat = 2
        static let borderWidthUnSelected: CGFloat = 1
        static let spacing: CGFloat = 8
    }
}

#Preview {
    VStack {
        OnboardingPickerOptionView(text: "Lose  weight",
                                   description: "I work on my feet and move around throughout the day",
                                   isSelected: false,
                                   onTap: {})
        OnboardingPickerOptionView(text: "Feel more energetic",
                                   description: nil,
                                   isSelected: true,
                                   onTap: {})
    }
}

