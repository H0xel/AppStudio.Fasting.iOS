//
//  HintQuestionContentView.swift
//
//
//  Created by Denis Khlopin on 08.03.2024.
//

import SwiftUI

struct HintQuestionContentView: View {
    let questionsContent: QuestionContent
    var body: some View {
        HStack(alignment: .center, spacing: .horizontalSpacing) {
            questionsContent.icon
                .resizable()
                .frame(width: .iconSize, height: .iconSize)
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, .iconVerticalPadding)

            Text(questionsContent.title)
                .font(.poppinsMedium(.body))
            Spacer()
        }

        // MARK: - Answears
        VStack(alignment: .leading, spacing: .spacing) {
            ForEach(questionsContent.answers, id: \.self) { answear in
                Text(answear)
                    .font(.poppins(.body))
            }
        }
        .padding(.bottom, .bottomPadding)
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let spacing: CGFloat = 12
    static let emptySpacing: CGFloat = 0

    static let iconSize: CGFloat = 48
    static let iconVerticalPadding: CGFloat = 8
    static let bottomPadding: CGFloat = 28
    static let horizontalSpacing: CGFloat = 12
}
