//
//  HintScreen.swift
//
//
//  Created by Denis Khlopin on 07.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct HintScreen: View {
    @StateObject var viewModel: HintViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: .emptySpacing) {
                // MARK: - TopicTitle
                Text(viewModel.topic.title)
                    .font(.poppinsBold(.headerS))
                    .padding(.bottom, .titleBottomPadding)
                    .foregroundStyle(Color.studioBlackLight)

                ForEach(viewModel.topic.content, id: \.self) { content in
                    switch content {
                    case .coloredDotes(let dotsContent):
                        HintFastingContentView(fastingContent: dotsContent)
                    case .contentWidthBadge(let contentWithBadge):
                        HintBodyMassContentView(content: contentWithBadge)
                    case .novaQuestion(let novaContent):
                        HintNovaQuestionsContentView(
                            novaQuestionsContent: novaContent,
                            onQuestionTap: viewModel.onTap(novaQuestion:)
                        )
                    case .paragraph(let paragraphContent):
                        HintFastingInfoView(fastingInfo: paragraphContent)
                    case .question(let paragraphContent):
                        HintQuestionContentView(questionsContent: paragraphContent)
                    }
                }
            }
            .foregroundStyle(Color.studioBlackLight)
            .padding(.horizontal, .horizontalPadding)
            .padding(.top, .topPadding)
            .padding(.bottom, .bottomPadding)
        }
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let emptySpacing: CGFloat = 0
    static let titleBottomPadding: CGFloat = 24
    static let horizontalPadding: CGFloat = 24
    static let topPadding: CGFloat = 32
    static let bottomPadding: CGFloat = 48
}

struct HintScreen_Previews: PreviewProvider {
    static var previews: some View {
        HintScreen(
            viewModel: HintViewModel(
                input: HintInput(topic: .init(title: "", content: [])),
                output: { _ in }
            )
        )
    }
}
