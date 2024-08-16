//
//  TextWithCursorView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 16.08.2024.
//

import SwiftUI

struct TextWithCursorView: View {

    @Binding var isTextSelected: Bool
    let text: String
    let isFocused: Bool

    @State private var isCursorPresented: Bool = false

    var body: some View {
        HStack(spacing: .zero) {
            Text("\(text)")
                .truncationMode(.head)
                .foregroundStyle(Color.studioBlackLight)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
            if isFocused {
                Color.studioBlackLight
                    .frame(width: .cursorWidth, height: .cursorHeight)
                    .opacity(isCursorPresented && !isTextSelected ? 1 : 0)
            }
        }
        .background {
            if isTextSelected {
                Color.studioGreyStrokeFill
            }
        }
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
    }
}

private extension CGFloat {
    static let cursorWidth: CGFloat = 1.5
    static let cursorHeight: CGFloat = 24
}

#Preview {
    TextWithCursorView(isTextSelected: .constant(true), text: "9", isFocused: true)
}
