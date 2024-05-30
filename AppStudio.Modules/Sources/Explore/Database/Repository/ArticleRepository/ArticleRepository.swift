//  
//  ArticleRepositoryService.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//
import CoreData

protocol ArticleRepository {
    func articleObserver(stackId: String) -> ArticleObserver
    func article(id: String) async throws -> Article?
    func articles(stackId: String) async throws -> [Article]
    func favoriteArticles(type: ArticleType) async throws -> [Article]
    func favoriteArticleObserver() -> ArticleObserver
    func save(_ article: Article) async throws -> Article
    func deleteAll() async throws
    func delete(byIds ids: [String]) async throws -> NSBatchDeleteResult
}
