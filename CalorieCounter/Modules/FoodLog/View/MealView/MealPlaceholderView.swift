//
//  MealPlaceholderView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 21.12.2023.
//

import SwiftUI
import AppStudioStyles

struct MealPlaceholderView: View {

    let text: String
    @State private var viewWidth: CGFloat = 0
    @State private var gradientLocation: CGFloat = 0

    var body: some View {

        VStack(alignment: .leading, spacing: .spacing) {
            HStack(alignment: .top, spacing: .spacing) {
                Text(text)
                    .lineLimit(2)
                    .font(.poppinsBold(.buttonText))
                    .aligned(.left)
                    .frame(width: viewWidth * 2 / 3)
                PlaceholderGradient(currentLocation: gradientLocation)
            }
            HStack(spacing: .spacing) {
                PlaceholderGradient(currentLocation: gradientLocation)
                    .frame(width: viewWidth * 2 / 3)
                PlaceholderGradient(currentLocation: gradientLocation)
            }
        }
        .modifier(WithGradientLocationTimerModifier(gradientLocation: $gradientLocation))
        .withViewWidthPreferenceKey
        .onViewWidthPreferenceKeyChange { width in
            viewWidth = width
        }
        .padding(.leading, .leadingPadding)
        .padding(.trailing, .trailingPadding)
        .padding(.vertical, .verticalPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 12
    static let gradientHeight: CGFloat = 36
    static let gradientCornerRadius: CGFloat = 8
    static let verticalPadding: CGFloat = 12
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 20
}

#Preview {
    VStack {
        NotFoundMealPlaceholderView() {}
        MealPlaceholderView(text: "3 egg omelette with ham, cheese")
        MealPlaceholderView(text: "3 egg omelette with ham, cheese")
    }
    .background(Color.black)
}
