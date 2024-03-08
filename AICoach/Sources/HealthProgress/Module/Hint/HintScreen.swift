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

                // MARK: - Question Content
                if let questionsContent = viewModel.topic.questionsContent {
                    HintQuestionContentView(questionsContent: questionsContent)
                }

                // MARK: - Body Mass Index Content
                if let bodyMassContent = viewModel.topic.bodyMassContent {
                    HintBodyMassContentView(bodyMassContent: bodyMassContent)
                }

                // MARK: - Nova Questions Content
                if let novaQuestionsContent = viewModel.topic.novaQuestionsContent {
                    HintNovaQuestionsContentView(
                        novaQuestionsContent: novaQuestionsContent,
                        onQuestionTap: viewModel.onTap(novaQuestion:)
                    )
                }

                // MARK: - Fasting
                if let fastingContent = viewModel.topic.fastingContent {
                    HintFastingContentView(fastingContent: fastingContent)
                }

                // MARK: - Fasting info
                if let fastingInfo = viewModel.topic.fastingInfo {
                    HintFastingInfoView(fastingInfo: fastingInfo)
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
                //                input: HintInput(topic: .bodyMassIndexTopic(index: .obese)),
                input: HintInput(topic: .fasting()),
                output: { _ in }
            )
        )
    }
}
