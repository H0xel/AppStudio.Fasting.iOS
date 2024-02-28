//
//  CoachTextFieldView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI

struct CoachTextFieldView: View {

    @Binding var text: String
    let styles: CoachStyles

    var body: some View {
        TextField(String.askQuestions,
                  text: .init(get: { text },
                              set: { text in self.text = text }),
                  axis: .vertical)
        .font(styles.fonts.body)
        .foregroundStyle(styles.colors.accent)
        .padding(.horizontal, .textFieldHorizontalPadding)
        .padding(.vertical, .textFieldVerticalPadding)
        .frame(minHeight: .textFieldMinHeight)
        .background(styles.colors.coachGrayFillProgress)
        .continiousCornerRadius(.cornerRadius)
        .lineLimit(5)
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 20
    static let textFieldVerticalPadding: CGFloat = 12
    static let textFieldHorizontalPadding: CGFloat = 16
    static let textFieldMinHeight: CGFloat = 48
}

private extension String {
    static let askQuestions = "CoachTextField.askQuestions".localized(bundle: .coachBundle)
}

#Preview {
    CoachTextFieldView(text: .constant("Hello"), styles: .mock)
}
