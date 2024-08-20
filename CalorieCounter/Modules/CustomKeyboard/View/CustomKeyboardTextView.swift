//
//  CustomKeyboardTextView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.06.2024.
//

import SwiftUI

struct CustomKeyboardTextView: View {

    @Binding var isTextSelected: Bool
    @Binding var isFocused: Bool
    let text: String
    let units: String
    let grammsValue: String?

    var body: some View {
        HStack(spacing: .spacing) {
            TextWithCursorView(isTextSelected: $isTextSelected, text: text, isFocused: isFocused)
                .onTapGesture {
                    isTextSelected = true
                }
            Text(units)
                .foregroundStyle(Color.studioGreyPlaceholder)
                .lineLimit(1)
            Spacer()
            if let grammsValue {
                HStack(spacing: .grammsSpacing) {
                    Circle()
                        .fill(Color.studioGreyPlaceholder)
                        .frame(width: .dotWidth)
                    Text(grammsValue)
                        .foregroundStyle(Color.studioGreyPlaceholder)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .font(.poppins(.body))
        .padding(.horizontal, .horizontalPadding)
        .padding(.vertical, .verticalPadding)
        .background(Color.studioGrayFillProgress)
        .continiousCornerRadius(.cornerRadius)
        .animation(.bouncy(duration: 0.2), value: isTextSelected)
        .onTapGesture {
            isTextSelected = false
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    isFocused = true
                }
        )
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 12
    static let spacing: CGFloat = 4
    static let cursorSpacing: CGFloat = 0
    static let cursorWidth: CGFloat = 1.5
    static let cursorHeight: CGFloat = 24
    static let cornerRadius: CGFloat = 56
    static let dotWidth: CGFloat = 4
    static let grammsSpacing: CGFloat = 8
}

#Preview {
    CustomKeyboardTextView(isTextSelected: .constant(true),
                           isFocused: .constant(true),
                           text: "150",
                           units: "g",
                           grammsValue: "85 g")
}
