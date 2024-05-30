//  
//  ArticleServiceImpl.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies

class ArticleServiceImpl: ArticleService {
    @Dependency(\.articleRepository) private var articleRepository

    func articles(stackId: String) async throws -> [Article] {
        try await articleRepository.articles(stackId: stackId)
    }

    func favoriteArticles(type: ArticleType) async throws -> [Article] {
        try await articleRepository.favoriteArticles(type: type)
    }

    func toggleFavorite(article: Article) async throws -> Article {
        var article = article
        article.isFavorite.toggle()
        return try await save(article)
    }

    func save(_ article: Article) async throws -> Article {
        try await articleRepository.save(article)
    }

    func reload(_ article: Article) async throws -> Article {
        var updatedArticle = article
        let prevArticle = try await articleRepository.article(id: article.id) ?? article
        updatedArticle.isFavorite = prevArticle.isFavorite
        updatedArticle.content = prevArticle.content
        updatedArticle.imageURL = prevArticle.imageURL
        return try await articleRepository.save(updatedArticle)
    }
    
    func deleteAll() async throws {
        try await articleRepository.deleteAll()
    }
    
    func articleObserver(stackId: String) -> ArticleObserver {
        articleRepository.articleObserver(stackId: stackId)
    }
    
    func article(id: String) async throws -> Article? {
        try await articleRepository.article(id: id)
    }

    func delete(ids: [String]) async throws {
        _ = try await articleRepository.delete(byIds: ids)
    }
    func favoriteArticleObserver() -> ArticleObserver {
        articleRepository.favoriteArticleObserver()
    }
}
