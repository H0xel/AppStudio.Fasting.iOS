//  
//  ArticleRepositoryDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies

extension DependencyValues {
    var articleRepository: ArticleRepository {
        self[ArticleRepositoryKey.self]
    }
}

private enum ArticleRepositoryKey: DependencyKey {
    static var liveValue = ArticleRepositoryImpl()
}
