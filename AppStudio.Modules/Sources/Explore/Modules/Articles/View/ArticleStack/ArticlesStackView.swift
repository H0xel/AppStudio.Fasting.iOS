//
//  ArticlesStackView.swift
//
//
//  Created by Руслан Сафаргалеев on 19.04.2024.
//

import SwiftUI
import AppStudioStyles

struct ArticlesStackView: View {

    @StateObject var viewModel: ArticlesStackViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(viewModel.stack.title)
                .font(.poppinsBold(.buttonText))
                .foregroundStyle(Color.studioBlackLight)
                .frame(height: .titleHeight)
                .aligned(.left)
                .padding(.vertical, .titleVerticalPadding)
                .padding(.horizontal, .titleHorizontalPadding)

            ScrollView(.horizontal) {
                HStack(spacing: .zero) {
                    Spacer(minLength: .horizontalSpacing)
                    if !viewModel.isInitialized || viewModel.articles.isEmpty {
                        ArticlesStackPlaceholderView(size: viewModel.stack.size)
                    } else {
                        LazyHStack(spacing: .spacing) {
                            ForEach(viewModel.articles, id: \.self) { article in
                                ArticlePreviewView(viewModel: .init(article: article),
                                                   style: viewModel.stack.size.previewSize) { article, image in
                                    viewModel.onArticleTap(article, image: image)
                                }
                            }
                        }
                    }
                    Spacer(minLength: .horizontalSpacing)
                }
            }
            .scrollIndicators(.hidden)
            if let tricks = viewModel.stack.novaTricks {
                ArticlesNovaView(content: tricks,
                                 onQuestionTap: viewModel.onQuestionTap)
                .padding(.top, .tricksTopPadding)
                .padding(.horizontal, .horizontalSpacing)
            }
        }
    }
}

private extension CGFloat {
    static let titleVerticalPadding: CGFloat = 16
    static let titleHorizontalPadding: CGFloat = 36
    static let titleHeight: CGFloat = 25
    static let tricksTopPadding: CGFloat = 8
    static let spacing: CGFloat = 8
    static let horizontalSpacing: CGFloat = 16
}

#Preview {
    ScrollView(.vertical) {
        VStack {
            ArticlesStackView(viewModel: .init(stack: .mockLarge,
                                               output: { _ in }))
            ArticlesStackView(viewModel: .init(stack: .mockSmall,
                                               output: { _ in }))
        }
    }
    .background(Color.studioGrayFillProgress)
}
