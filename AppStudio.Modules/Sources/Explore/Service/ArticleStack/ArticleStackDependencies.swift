//  
//  ArticleStackDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies

extension DependencyValues {
    var articleStackService: ArticleStackService {
        self[ArticleStackServiceKey.self]
    }
}

private enum ArticleStackServiceKey: DependencyKey {
    static var liveValue: ArticleStackService = ArticleStackServiceImpl()
}
