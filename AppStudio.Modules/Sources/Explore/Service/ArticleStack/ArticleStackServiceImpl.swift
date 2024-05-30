//  
//  ArticleStackServiceImpl.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Dependencies

class ArticleStackServiceImpl: ArticleStackService {
    @Dependency(\.articleStackRepository) private var articleStackRepository

    func stacks() async throws -> [ArticleStack] {
        try await articleStackRepository.stacks()
    }

    func save(_ stack: ArticleStack) async throws -> ArticleStack {
        try await articleStackRepository.save(stack)
    }

    func deleteAll() async throws {
        try await articleStackRepository.deleteAll()
    }

    func delete(ids: [String]) async throws {
        _ = try await articleStackRepository.delete(byIds: ids)
    }
}
