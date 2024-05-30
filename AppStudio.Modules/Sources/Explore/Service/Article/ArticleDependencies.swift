//  
//  ArticleDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies

extension DependencyValues {
    var articleService: ArticleService {
        self[ArticleServiceKey.self]
    }
}

private enum ArticleServiceKey: DependencyKey {
    static var liveValue: ArticleService = ArticleServiceImpl()
}
