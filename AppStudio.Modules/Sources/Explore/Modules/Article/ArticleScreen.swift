//  
//  ArticleScreen.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import AppStudioUI

struct ArticleScreen: View {
    @StateObject var viewModel: ArticleViewModel
    @State private var imageScale: CGFloat = 1
    @State private var headerTitle: String?

    var body: some View {
        ScrollViewWithOffset {
            ArticleTitleView(imageScale: $imageScale, 
                             image: viewModel.image, 
                             title: viewModel.article.title, 
                             cookAmount: viewModel.article.cookTime)

            if let profile = viewModel.article.nutritionProfile {
                ArticleNutritionView(profile: profile)
                    .padding(.top, .profileTopPadding)
            }
            
            ArticleMarkDown(content: viewModel.article.content)
            
        } onOffsetChange: { offset in
            if offset < (-230 + UIDevice.safeAreaTopInset) {
                headerTitle = viewModel.article.title
            } else {
                headerTitle = nil
            }
            guard offset >= 0 else { return }
            imageScale = 1 + offset / 200
        }
        .ignoresSafeArea(edges: .top)
        .overlay(
            ArticleHeaderView(title: headerTitle,
                              isSaved: $viewModel.isSaved,
                              isFavourite: $viewModel.isFavourite,
                              action: viewModel.handle)

        )
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static var profileTopPadding: CGFloat = 32
}

struct ArticleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ArticleScreen(
            viewModel: ArticleViewModel(
                input: ArticleInput(article: .mock, previewImage: nil),
                output: { _ in }
            )
        )
    }
}
