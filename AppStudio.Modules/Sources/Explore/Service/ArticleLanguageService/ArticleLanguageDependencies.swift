//  
//  ArticleLanguageDependencies.swift
//  
//
//  Created by Denis Khlopin on 30.04.2024.
//

import Dependencies

extension DependencyValues {
    var articleLanguageService: ArticleLanguageService {
        self[ArticleLanguageServiceKey.self]
    }
}

private enum ArticleLanguageServiceKey: DependencyKey {
    static var liveValue: ArticleLanguageService = ArticleLanguageServiceImpl()
}
