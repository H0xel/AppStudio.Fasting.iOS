//  
//  ArticleStackService.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

protocol ArticleStackService {
    func stacks() async throws -> [ArticleStack]
    func save(_ stack: ArticleStack) async throws -> ArticleStack
    func deleteAll() async throws
    func delete(ids: [String]) async throws
}
