//  
//  ArticleRepositoryServiceImpl.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Foundation
import Dependencies
import MunicornCoreData

typealias ArticleObserver = CoreDataObserver<Article>

class ArticleRepositoryImpl: CoreDataBaseRepository<Article>, ArticleRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func articleObserver(stackId: String) -> ArticleObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = ArticleObserver(coreDataService: coreDataService)

        let request = Article.request()
        request.predicate = .init(format: "stackId = %@", stackId)
        request.sortDescriptors = [.init(key: "id", ascending: true)]
        observer.fetch(request: request)

        return observer
    }

    func articles(stackId: String) async throws -> [Article] {
        let request = Article.request()
        request.predicate = .init(format: "stackId = %@", stackId)
        request.sortDescriptors = [.init(key: "id", ascending: true)]
        return try await select(request: request)
    }

    func favoriteArticles(type: ArticleType) async throws -> [Article] {
        let request = Article.request()
        let predicates = [
            NSPredicate(format: "isFavorite = true"),
            NSPredicate(format: "type = %@", type.rawValue)
        ]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return try await select(request: request)
    }

    func article(id: String) async throws -> Article? {
        try await object(byId: id)
    }

    func favoriteArticleObserver() -> ArticleObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = ArticleObserver(coreDataService: coreDataService)
        let request = Article.request()
        request.predicate = NSPredicate(format: "isFavorite = true")
        request.sortDescriptors = [.init(key: "id", ascending: true)]
        observer.fetch(request: request)

        return observer
    }
}
