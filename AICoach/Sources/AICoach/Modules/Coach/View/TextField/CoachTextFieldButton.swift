//
//  CoachTextFieldButton.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI

struct CoachTextFieldButton: View {

    let text: String
    let styles: CoachStyles
    let isSuggestionsPresented: Bool
    let toggleSuggestions: (Bool) -> Void
    let onSend: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        if !text.isEmpty {
            CoachTextFieldButtonView(image: .arrowUp,
                                     backgroundColor: isEnabled ?
                                     styles.colors.accent : styles.colors.coachGrayFillProgress,
                                     foregroundColor: .white,
                                     onTap: onSend)
        } else if isSuggestionsPresented {
            CoachTextFieldButtonView(image: .chevronDown,
                                     backgroundColor: styles.colors.coachGrayFillProgress,
                                     foregroundColor: styles.colors.accent) {
                toggleSuggestions(false)
            }
        } else {
            CoachTextFieldButtonView(image: .textLeft,
                                     backgroundColor: styles.colors.coachGrayFillProgress,
                                     foregroundColor: styles.colors.accent) {
                toggleSuggestions(true)
            }
        }
    }
}

#Preview {
    CoachTextFieldButton(text: "Hello",
                         styles: .mock,
                         isSuggestionsPresented: true,
                         toggleSuggestions: { _ in },
                         onSend: {})
}
