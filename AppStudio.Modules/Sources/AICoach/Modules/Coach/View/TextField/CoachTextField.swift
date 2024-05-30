//
//  CoachTextField.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI
import Dependencies
import AppStudioStyles

enum CoachTextFieldOutput {
    case send(text: String)
    case regenerateSuggestions
    case toggleSuggestions(isPresented: Bool)
    case tapSuggestion(text: String, context: SuggestionContext)
}

struct CoachTextField: View {

    @Dependency(\.styles) private var styles

    @Binding var text: String
    let isSuggestionsPresented: Bool
    let suggestions: [String]
    let isKeywordsPresented: Bool
    let isWaitingForReply: Bool
    let maxPosition: CGFloat
    let output: (CoachTextFieldOutput) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            CoachSuggestionsView(suggestions: suggestions,
                                 maxPosition: maxPosition,
                                 isPresented: isSuggestionsPresented) {
                output(.regenerateSuggestions)
            } onTap: { suggestion in
                output(.tapSuggestion(text: suggestion, context: .list))
            }
            .hideKeyboardOnTap()
            .frame(height: isSuggestionsPresented ? nil : 0)

            HStack(alignment: .bottom, spacing: .spacing) {
                CoachTextFieldView(text: $text, styles: styles)
                CoachTextFieldButton(text: text,
                                     styles: styles,
                                     isSuggestionsPresented: isSuggestionsPresented) { isPresented in
                    output(.toggleSuggestions(isPresented: isPresented))
                } onSend: {
                    output(.send(text: text))
                }
                .disabled(isWaitingForReply)
            }
            .padding(.padding)
            .background(.white)
            .animation(nil, value: isSuggestionsPresented)
        }
        .background(.white)
        .corners([.topLeft, .topRight], with: isKeywordsPresented ? 0 : .cornerRadius)
        .modifier(TopBorderModifier(color: isKeywordsPresented ? .clear : styles.colors.coachGreyStrokeFill))
        .background(styles.colors.coachGrayFillProgress)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let cornerRadius: CGFloat = 20
    static let padding: CGFloat = 10
}

#Preview {
    ZStack {
        Color.red
        VStack {
            CoachTextField(text: .constant("What kind of exercise I can do while  fasting?"),
                           isSuggestionsPresented: true,
                           suggestions: [
                            "Tips to manage social eating pressure? What to eat before exercise?",
                            "What meals/snacks can help me stay full?",
                            "Can you help me with a workout plan?"
                           ],
                           isKeywordsPresented: false, 
                           isWaitingForReply: false, 
                           maxPosition: 20) { _ in }
        }
    }
}
