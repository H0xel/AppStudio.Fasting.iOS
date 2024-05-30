//  
//  FavouriteArticlesScreen.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct FavouriteArticlesScreen: View {
    @StateObject var viewModel: FavouriteArticlesViewModel

    var body: some View {
        view
            .navigationBarTitleDisplayMode(.inline)
            .navBarButton(placement: .principal,
                          content: NavigationTitle(title: .title),
                          action: {})
            .navBarButton(content: BackButton(),
                          action: viewModel.dismiss)
            .animation(.linear, value: viewModel.activeType)
    }

    @ViewBuilder
    private var view: some View {
        if viewModel.displayArticles.isEmpty {
            FavouriteArticlesEmptyView()
        } else {
            VStack(spacing: .zero) {
                if viewModel.hasBothTypes {
                    FavouriteArticlesFilterView(type: $viewModel.activeType)
                }
                FavouriteArticlesScrollView(
                    articles: viewModel.displayArticles,
                    onTap: { article, image in
                        viewModel.onArticleTap(article, previewImage: image)
                    })
            }
        }
    }
}

private extension String {
    static let title = "FavouriteArticlesScreen.title".localized(bundle: .module)
}

struct FavouriteArticlesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            FavouriteArticlesScreen(
                viewModel: FavouriteArticlesViewModel(
                    input: FavouriteArticlesInput(),
                    output: { _ in }
                )
            )
        }
    }
}
