//  
//  ArticleStackRepositoryDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies

extension DependencyValues {
    var articleStackRepository: ArticleStackRepository {
        self[ArticleStackRepositoryKey.self]
    }
}

private enum ArticleStackRepositoryKey: DependencyKey {
    static var liveValue = ArticleStackRepositoryImpl()
}
