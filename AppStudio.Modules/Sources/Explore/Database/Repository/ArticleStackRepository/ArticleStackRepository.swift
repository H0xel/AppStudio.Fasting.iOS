//  
//  ArticleStackRepositoryService.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//
import CoreData

protocol ArticleStackRepository {
    func stacks() async throws -> [ArticleStack]
    func save(_ stack: ArticleStack) async throws -> ArticleStack
    func deleteAll() async throws
    func delete(byIds ids: [String]) async throws -> NSBatchDeleteResult
}
