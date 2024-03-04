//
//  MealPlaceholderView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 21.12.2023.
//

import SwiftUI

struct MealPlaceholderView: View {

    let text: String
    @State private var viewWidth: CGFloat = 0
    @State private var gradientLocation: CGFloat = 0
    @State private var isMovingForward = true
    private let timer = Timer.publish(every: 0.02, on: .main, in: .default).autoconnect()

    var body: some View {

        VStack(alignment: .leading, spacing: .spacing) {
            HStack(alignment: .top, spacing: .spacing) {
                Text(text)
                    .lineLimit(2)
                    .font(.poppinsBold(.buttonText))
                    .aligned(.left)
                    .frame(width: viewWidth * 2 / 3)
                gradient
            }
            HStack(spacing: .spacing) {
                gradient
                    .frame(width: viewWidth * 2 / 3)
                gradient
            }
        }
        .onReceive(timer) { _ in
            gradientLocation += isMovingForward ? 0.01 : -0.01
            if gradientLocation > 1.2 {
                isMovingForward = false
            }
            if gradientLocation < -0.2 {
                isMovingForward = true
            }
        }
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

    private var gradient: some View {
        LinearGradient(stops: [
            .init(color: .studioGreyFillCard, location: -0.21),
            .init(color: .studioGreyStrokeFill.opacity(0.6), location: gradientLocation),
            .init(color: .studioGreyFillCard, location: 1.21)
        ], startPoint: .leading, endPoint: .trailing)
        .frame(height: .gradientHeight)
        .continiousCornerRadius(.gradientCornerRadius)
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
