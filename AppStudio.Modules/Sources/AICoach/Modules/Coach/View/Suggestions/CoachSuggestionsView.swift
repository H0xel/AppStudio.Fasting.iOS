//
//  CoachSuggestionsView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI
import Dependencies
import MunicornUtilities

struct CoachSuggestionsView: View {

    @Dependency(\.styles) private var styles

    let suggestions: [String]
    let regenerate: () -> Void
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            CoachSuggestionsTitleView(styles: styles, onTap: regenerate)
                .padding(.bottom, .titleBottomPadding)
            CoachSuggestionsStackView(suggestions: suggestions,
                                      styles: styles,
                                      onTap: onTap)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.bottom, .bottomPadding)
        .padding(.top, .topPadding)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 12
    static let topPadding: CGFloat = 16
    static let titleBottomPadding: CGFloat = 4
    static let dragAreaHeight: CGFloat = 23
    static let lineWidth: CGFloat = 32
    static let lineHeight: CGFloat = 2
    static let lineCornerRadius: CGFloat = 8
}

#Preview {
    ZStack {
        Color.red
        CoachSuggestionsView(suggestions: [
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snack can help me stay full?",
            "Can you help me with a workout plan?",
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snack can help me stay full?",
            "Can you help me with a workout plan?",
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snack can help me stay full?",
            "Can you help me with a workout plan?",
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snack can help me stay full?",
            "Can you help me with a workout plan?"
        ]) {} onTap: { _ in }
            .background(.white)
            .aligned(.bottom)
    }
}
