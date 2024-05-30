//  
//  ArticleStackRepositoryServiceImpl.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies
import MunicornCoreData

class ArticleStackRepositoryImpl: CoreDataBaseRepository<ArticleStack>, ArticleStackRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func stacks() async throws -> [ArticleStack] {
        try await selectAll()
    }
}
