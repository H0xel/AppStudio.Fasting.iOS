//
//  OnboardingPickerView.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioModels

public struct OnboardingPickerView<Option: OnboardingPickerOption>: View {

    private let title: String
    private let description: String?
    private let options: [Option]
    private let selectedOptions: [Option]
    private let bottomPadding: CGFloat
    private let onTap: (Option) -> Void

    public init(title: String,
                description: String?,
                options: [Option],
                selectedOptions: [Option],
                bottomPadding: CGFloat = 120,
                onTap: @escaping (Option) -> Void) {
        self.title = title
        self.description = description
        self.options = options
        self.selectedOptions = selectedOptions
        self.bottomPadding = bottomPadding
        self.onTap = onTap
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: .zero) {
                    Text(title)
                        .font(.poppins(.headerM))
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(.top, Layout.topPadding)
                        .multilineTextAlignment(.center)

                    if let description {
                        Text(description)
                            .foregroundStyle(Color.studioGrayText)
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
                                isSelected: selectedOptions.contains(option),
                                isRecommended: option.isRecommended
                            ) {
                                onTap(option)
                            }
                        }
                    }
                    .padding(.bottom, bottomPadding)
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
                             options: [HeightUnit.ft, .cm],
                             selectedOptions: []) { _ in }
    }
}

