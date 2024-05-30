//  
//  ArticlesViewModel.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import Dependencies
import SwiftUI

class ArticlesViewModel: BaseViewModel<ArticlesOutput> {

    @Dependency(\.articleStackService) private var articleStackService

    var router: ArticlesRouter!
    @Published private var articles: Articles = .mock
    @Published var stacks: [ArticleStack] = []

    init(input: ArticlesInput, output: @escaping ArticlesOutputBlock) {
        super.init(output: output)
        loadStacks()
    }

    func presentFavorites() {
        router.presentFavorites()
    }

    func handle(articleStackOutput output: ArticlesStackOutput) {
        switch output {
        case .questionTap(let question):
            onNovaQuestionTap(question)
        case let .articleTap(article, image):
            presentArticle(article, previewImage: image)
        }
    }

    func loadStacks() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let stacks = try await articleStackService.stacks()
            self.stacks = stacks
        }
    }

    private func onNovaQuestionTap(_ question: String) {
        output(.nova(question))
    }

    private func presentArticle(_ article: Article, previewImage: Image?) {
        router.present(article: article, previewImage: previewImage)
    }
}
