//
//  OnboardingPickerView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

struct OnboardingPickerView<Option: OnboardingPickerOption>: View {

    let title: String
    let description: String?
    let options: [Option]
    let selectedOptions: [Option]
    let onTap: (Option) -> Void

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: .zero) {
                    Text(title)
                        .font(.poppins(.headerM))
                        .foregroundStyle(.accent)
                        .padding(.top, Layout.topPadding)
                        .multilineTextAlignment(.center)

                    if let description {
                        Text(description)
                            .foregroundStyle(.fastingGrayText)
                            .font(.poppins(.body))
                            .padding(.top, Layout.descriptionTopPadding)
                            .multilineTextAlignment(.center)
                    }
                    Spacer(minLength: Layout.minTopSpacing)
                    VStack(spacing: Layout.optionsSpacing) {
                        ForEach(options) { option in
                            OnboardingPickerOptionView(
                                text: option.title,
                                description: option.description,
                                isSelected: selectedOptions.contains(option)
                            ) {
                                onTap(option)
                            }
                        }
                    }
                    Spacer(minLength: Layout.bottomPadding)
                }
                .frame(minHeight: geometry.size.height)
            }
            .scrollIndicators(.hidden)
        }
    }
}

private extension OnboardingPickerView {
    enum Layout {
        static var topPadding: CGFloat { 24 }
        static var descriptionTopPadding: CGFloat { 16 }
        static var optionsSpacing: CGFloat { 8 }
        static var bottomPadding: CGFloat { 120 }
        static var minTopSpacing: CGFloat { 48 }
    }
}

#Preview {
    NavigationStack {
        OnboardingPickerView(title: "What do you want to achieve?",
                             description: "Pick as many as you like",
                             options: FastingGoal.allCases,
                             selectedOptions: []) { _ in }
    }
}
