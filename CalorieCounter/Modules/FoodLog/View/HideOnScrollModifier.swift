//
//  HiddingTextFieldModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 03.06.2024.
//

import SwiftUI

struct HideOnScrollModifier: ViewModifier {

    let scrollOffset: CGFloat
    let canHide: Bool
    var maxOffset: CGFloat = -50

    @State private var textFieldBottomPadding: CGFloat = 0
    @State private var previousSuggestionsScrollOffset: CGFloat = 0
    @State private var textFieldPaddingTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .opacity(isPresented ? 1 : 0)
            .onChange(of: scrollOffset) { offset in
                textFieldPaddingTask?.cancel()
                guard canHide else {
                    textFieldBottomPadding = 0
                    return
                }
                guard offset >= 0 else { return }
                let difference = offset - previousSuggestionsScrollOffset

                if difference > 0 { // Go Down
                    textFieldBottomPadding = max(maxOffset, textFieldBottomPadding - difference)
                } else { // Go Up
                    textFieldBottomPadding = min(0, textFieldBottomPadding - difference)
                }
                previousSuggestionsScrollOffset = offset
                guard textFieldBottomPadding < 0 else {
                    return
                }
                textFieldPaddingTask = Task {
                    try? await Task.sleep(seconds: 0.5)
                    guard !Task.isCancelled else { return }
                    withAnimation(.bouncy) {
                        if textFieldBottomPadding >= maxOffset / 2 {
                            textFieldBottomPadding = 0
                        } else {
                            textFieldBottomPadding = maxOffset
                        }
                    }
                }
            }
            .offset(y: -textFieldBottomPadding)
    }

    private var isPresented: Bool {
        textFieldBottomPadding > maxOffset
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(HideOnScrollModifier(scrollOffset: 100, canHide: true))
}
