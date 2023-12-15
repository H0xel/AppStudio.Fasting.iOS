//
//  OnboardingPickerOptionView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

struct OnboardingPickerOptionView: View {

    let text: String
    let description: String?
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Layout.spacing) {
                Text(text)
                    .foregroundStyle(.accent)
                    .font(.poppins(.body))
                    .aligned(.left)

                if let description {
                    Text(description)
                        .font(.poppins(.body))
                        .foregroundStyle(.fastingGrayText)
                        .aligned(.left)
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(isSelected ? .white : Color(.fastingOnboardingPicker))
            .continiousCornerRadius(Layout.cornerRadius)
            .border(configuration: .init(
                cornerRadius: Layout.cornerRadius,
                color: .accent,
                lineWidth: isSelected ? Layout.borderWidth : .zero)
            )
        }
    }
}

private extension OnboardingPickerOptionView {
    enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
        static let borderWidth: CGFloat = 2
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
