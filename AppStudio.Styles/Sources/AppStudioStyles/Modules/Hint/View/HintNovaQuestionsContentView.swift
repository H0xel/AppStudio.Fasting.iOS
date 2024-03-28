//
//  SwiftUIView.swift
//  
//
//  Created by Denis Khlopin on 08.03.2024.
//

import SwiftUI

struct HintNovaQuestionsContentView: View {
    let novaQuestionsContent: NovaQustionsContent
    let onQuestionTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            HStack(alignment: .center, spacing: .horizontalSpacing) {
                novaQuestionsContent.icon
                    .resizable()
                    .frame(width: .iconSize, height: .iconSize)
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, .iconVerticalPadding)

                Text(novaQuestionsContent.title)
                    .font(.poppinsMedium(.body))
                Spacer()
            }

            ForEach(novaQuestionsContent.questions, id: \.self) { question in
                Text(question)
                    .padding(.vertical, .questionVerticalPadding)
                    .padding(.horizontal, .questionHorizontalPadding)
                    .overlay(
                        RoundedRectangle(cornerRadius: .questionCornerRadius)
                            .stroke(Color.studioGreyStrokeFill, lineWidth: .questionBorderWidth)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: .questionCornerRadius))
                    .onTapGesture {
                        onQuestionTap(question)
                    }
            }
        }
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let spacing: CGFloat = 8
    static let emptySpacing: CGFloat = 0
    static let horizontalSpacing: CGFloat = 12
    static let iconSize: CGFloat = 48
    static let iconVerticalPadding: CGFloat = 12

    static let questionVerticalPadding: CGFloat = 12
    static let questionHorizontalPadding: CGFloat = 16
    static let questionCornerRadius: CGFloat = 68
    static let questionBorderWidth: CGFloat = 0.5


    static let phaseHeight: CGFloat = 34
    static let bottomPadding: CGFloat = 24
}

#Preview {
    HintNovaQuestionsContentView(
        novaQuestionsContent: .init(
            title: "HintNovaQuestionsContent", 
            icon: .arrowCirclepath,
            questions: ["Question 1 String", "Question 2 String"]
        )) { _ in }
}
