//
//  InActiveFastingArticleScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioFoundation
import AppStudioUI

struct InActiveFastingArticleScreen: View {
    @StateObject var viewModel: InActiveFastingArticleViewModel

    var body: some View {
        VStack(spacing: .zero) {
            InActiveFastingHeader(action: viewModel.closeTapped)

            ScrollView(.vertical, showsIndicators: false) {

                Text(viewModel.fastingInActiveStage.buttonTitle)
                    .font(.poppins(.headerL))
                    .foregroundStyle(.white)
                    .padding(.bottom, Layout.titleBottomPadding)
                    .padding(.horizontal, Layout.titleHorizontalPadding)
                    .aligned(.bottomLeft)
                    .background(FastingInActiveArticle.linearGradient)

                VStack(spacing: .zero) {
                    if let image = viewModel.fastingInActiveStage.articleImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, Layout.imageBottomPadding)
                    }

                    Text(viewModel.fastingInActiveStage.description)
                        .lineSpacing(Layout.descriptionLineSpacing)
                        .font(.poppins(.buttonText))
                        .padding(.bottom, Layout.descriptionBottomPadding)

                    ForEach(Array(viewModel.fastingInActiveStage.viewData), id: \.title.localized) { viewData in
                        InActiveFastingListView(viewData: viewData)
                    }
                }
                .padding(.all, Layout.contentPadding)
                .background(Color.white)
            }
            .background(
                VStack(spacing: .zero) {
                    FastingInActiveArticle.linearGradient
                    Color.white
                }
            )
        }
    }
}

private extension InActiveFastingArticleScreen {
    enum Layout {
        static let contentPadding: CGFloat = 32
        static let descriptionBottomPadding: CGFloat = 28
        static let descriptionLineSpacing: CGFloat = 2
        static let titleBottomPadding: CGFloat = 16
        static let titleHorizontalPadding: CGFloat = 32
        static let imageHeight: CGFloat = 212
        static let imageBottomPadding: CGFloat = 32
    }
}

struct InActiveFastingArticleScreen_Previews: PreviewProvider {
    static var previews: some View {
        InActiveFastingArticleScreen(
            viewModel: InActiveFastingArticleViewModel(
                input: InActiveFastingArticleInput(fastingInActiveStage: .howToPrepareForFasting),
                output: { _ in }
            )
        )
    }
}
