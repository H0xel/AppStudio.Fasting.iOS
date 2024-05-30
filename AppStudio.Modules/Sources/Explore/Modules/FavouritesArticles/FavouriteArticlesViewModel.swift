//  
//  FavouriteArticlesViewModel.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import Dependencies
import SwiftUI

class FavouriteArticlesViewModel: BaseViewModel<FavouriteArticlesOutput> {

    @Dependency(\.articleService) private var articleService

    var router: FavouriteArticlesRouter!
    @Published private var articles: [Article] = []
    @Published private var recipes: [Article] = []
    @Published var activeType: ArticleType = .recipe
    private var articleObserver: ArticleObserver?


    init(input: FavouriteArticlesInput, output: @escaping FavouriteArticlesOutputBlock) {
        super.init(output: output)
        loadArticles()
    }

    var hasBothTypes: Bool {
        !recipes.isEmpty && !articles.isEmpty
    }

    var displayArticles: [Article] {
        switch activeType {
        case .article: articles
        case .recipe: recipes
        }
    }

    func dismiss() {
        router.dismiss()
    }

    func onArticleTap(_ article: Article, previewImage: Image?) {
        router.presentArticle(article, previewImage: previewImage)
    }

    func loadArticles() {
        articleObserver = articleService.favoriteArticleObserver()
        articleObserver?.results
            .receive(on: DispatchQueue.main)
            .sink(with: self, receiveValue: { this, favoriteArticles in
                this.articles = favoriteArticles.filter { $0.type == .article }
                this.recipes = favoriteArticles.filter { $0.type == .recipe }
                if !this.recipes.isEmpty {
                    this.activeType = .recipe
                } else {
                    this.activeType = .article
                }

            }).store(in: &cancellables)
    }
}
