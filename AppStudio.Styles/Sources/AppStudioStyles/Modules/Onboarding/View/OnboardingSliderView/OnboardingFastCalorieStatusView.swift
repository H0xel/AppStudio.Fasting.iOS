//
//  OnboardingFastCalorieStatusView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI

public struct OnboardingFastCalorieStatusView: View {
    let viewData: ViewData

    public var body: some View {
        HStack(spacing: .zero) {
            Spacer()
            Text(viewData.title)
                .font(.poppins(.body))
                .foregroundStyle(.white)
                .padding(.horizontal, .titleHorizontalPadding)
                .padding(.vertical, .titleVerticalPadding)
                .background(viewData.backgroundColor)
                .continiousCornerRadius(.cornerRadius)
            Spacer()
        }
        .padding(.vertical, .verticalPadding)
    }
}

public extension OnboardingFastCalorieStatusView {
    struct ViewData {
        let title: String
        let backgroundColor: Color

        public init(title: String, backgroundColor: Color) {
            self.title = title
            self.backgroundColor = backgroundColor
        }
    }
}

public extension OnboardingFastCalorieStatusView.ViewData {
    static var normal: OnboardingFastCalorieStatusView.ViewData  {
        .init(title: "Normal", backgroundColor: .studioGreen)
    }

    static var notNormal: OnboardingFastCalorieStatusView.ViewData  {
        .init(title: "Not Normal", backgroundColor: .studioRed)
    }
}


private extension CGFloat {
    static var titleHorizontalPadding: CGFloat { 16 }
    static var titleVerticalPadding: CGFloat { 10 }
    static var cornerRadius: CGFloat { 56 }
    static var verticalPadding: CGFloat { 24 }
}
