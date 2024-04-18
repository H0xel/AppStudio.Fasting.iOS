//
//  CoachSuggestionsStackView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI

struct CoachSuggestionsStackView: View {

    let suggestions: [String]
    let styles: CoachStyles
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            ForEach(suggestions, id: \.self) { suggestion in
                Button {
                    onTap(suggestion)
                } label: {
                    Text(suggestion)
                        .font(styles.fonts.body)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, .textVerticalPadding)
                        .padding(.horizontal, .textHorizontalPadding)
                        .border(configuration: .init(cornerRadius: .cornerRadius,
                                                     color: styles.colors.coachGreyStrokeFill,
                                                     lineWidth: .textBorderWidth))
                }
                .transition(.push(from: .top))
                .id(UUID())
            }
        }
    }
}

private extension CGFloat {
    static let textVerticalPadding: CGFloat = 12
    static let textHorizontalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    static let textBorderWidth: CGFloat = 0.5
    static let spacing: CGFloat = 8
}

#Preview {
    CoachSuggestionsStackView(
        suggestions: [
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snack can help me stay full?",
            "Can you help me with a workout plan?"
        ],
        styles: .mock,
        onTap: { _ in })
}
