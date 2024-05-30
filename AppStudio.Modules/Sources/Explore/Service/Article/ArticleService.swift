//  
//  ArticleService.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

protocol ArticleService {
    func articles(stackId: String) async throws -> [Article]
    func favoriteArticles(type: ArticleType) async throws -> [Article]
    func toggleFavorite(article: Article) async throws -> Article
    func save(_ article: Article) async throws -> Article
    func reload(_ article: Article) async throws -> Article
    func deleteAll() async throws
    func articleObserver(stackId: String) -> ArticleObserver
    func favoriteArticleObserver() -> ArticleObserver
    func article(id: String) async throws -> Article?
    func delete(ids: [String]) async throws
}
