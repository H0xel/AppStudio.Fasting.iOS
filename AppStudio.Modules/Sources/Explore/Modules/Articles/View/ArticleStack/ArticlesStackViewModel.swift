//
//  ArticlesStackViewModel.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Foundation
import Dependencies
import AppStudioUI
import SwiftUI

enum ArticlesStackOutput {
    case questionTap(String)
    case articleTap(Article, Image?)
}

class ArticlesStackViewModel: BaseViewModel<ArticlesStackOutput> {

    @Dependency(\.articleService) private var articleService

    let stack: ArticleStack
    @Published var articles: [Article] = []
    @Published var isInitialized = false
    private var observer: ArticleObserver?

    init(stack: ArticleStack, output: @escaping ViewOutput<ArticlesStackOutput>) {
        self.stack = stack
        super.init(output: output)
        loadArticles()
    }

    func onQuestionTap(_ question: String) {
        output(.questionTap(question))
    }

    func onArticleTap(_ article: Article, image: Image?) {
        output(.articleTap(article, image))
    }

    private func loadArticles() {
        observer = articleService.articleObserver(stackId: stack.id)
        observer?.results
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, articles in
                this.articles = articles.filter { !$0.imageId.trim.isEmpty && !$0.content.trim.isEmpty }
                this.isInitialized = true
            }
            .store(in: &cancellables)
    }
}
