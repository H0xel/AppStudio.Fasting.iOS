//
//  ArticlesNovaView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI
import AppStudioStyles

struct ArticlesNovaView: View {

    let content: NovaTricks
    let onQuestionTap: (String) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .titleSpacing) {
                Image.coachIcon
                    .resizable()
                    .frame(width: .imageWidth, height: .imageWidth)
                if let title = content.title {
                    Text(title)
                        .font(.poppinsMedium(.body))
                        .foregroundStyle(Color.studioBlackLight)
                        .aligned(.left)
                }
            }
            .padding(.vertical, .titleVerticalPadding)
            .padding(.leading, .titleLeadingPadding)
            TokenContainerView(tokens: content.questions) { question in
                Button(action: {
                    onQuestionTap(question)
                }, label: {
                    Text(question)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(.horizontal, .tokenHorizontalPadding)
                        .padding(.vertical, .tokenVerticalPadding)
                        .background(.white)
                        .continiousCornerRadius(.tokenCornerRadius)
                })
            }
        }
        .padding(.bottom, .bottomPadding)
    }
}

private extension CGFloat {
    static let imageWidth: CGFloat = 24
    static let titleVerticalPadding: CGFloat = 12
    static let titleLeadingPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 24
    static let tokenHorizontalPadding: CGFloat = 16
    static let tokenVerticalPadding: CGFloat = 14.5
    static let tokenCornerRadius: CGFloat = 44
    static let titleSpacing: CGFloat = 8
}

#Preview {
    ZStack {
        Color.studioGrayFillProgress
        ArticlesNovaView(content: .mock, onQuestionTap: { _ in })
    }
}
