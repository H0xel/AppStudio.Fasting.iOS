//
//  CustomKeyboardTextView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.06.2024.
//

import SwiftUI

struct CustomKeyboardTextView: View {

    @Binding var isTextSelected: Bool
    let text: String
    let units: String
    let grammsValue: String?

    @State private var isCursorPresented: Bool = false

    var body: some View {
        HStack(spacing: .spacing) {
            HStack(spacing: .cursorSpacing) {
                Text("\(text)")
                    .truncationMode(.head)
                    .foregroundStyle(Color.studioBlackLight)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Color.studioBlackLight
                    .frame(width: .cursorWidth, height: .cursorHeight)
                    .opacity(isCursorPresented ? 1 : 0)
            }
            .background {
                if isTextSelected {
                    Color.studioGreyStrokeFill
                }
            }
            .onTapGesture {
                isTextSelected = true
            }
            Text(units)
                .foregroundStyle(Color.studioGreyPlaceholder)
            Spacer()
            if let grammsValue {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.studioGreyPlaceholder)
                        .frame(width: 4)
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
        .onChange(of: isCursorPresented) { isCursorPresented in
            let delay: TimeInterval = isCursorPresented ? 0.7 : 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.isCursorPresented.toggle()
            }
        }
        .onAppear {
            isCursorPresented = true
        }
        .animation(.easeInOut(duration: 0.1), value: isCursorPresented)
        .animation(.bouncy(duration: 0.2), value: isTextSelected)
        .onTapGesture {
            isTextSelected = false
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 12
    static let spacing: CGFloat = 4
    static let cursorSpacing: CGFloat = 2
    static let cursorWidth: CGFloat = 1.5
    static let cursorHeight: CGFloat = 24
    static let cornerRadius: CGFloat = 56
}

#Preview {
    CustomKeyboardTextView(isTextSelected: .constant(true), text: "150", units: "g", grammsValue: "85 g")
}
