//  
//  CoachMessageRepositoryService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

protocol CoachMessageRepository {
    func messages() async throws -> [CoachMessage]
    func save(_ message: CoachMessage) async throws -> CoachMessage
    func save(_ messages: [CoachMessage]) async throws
    func coachMessageOsberver() -> CoachMessageObserver
    func deleteAll() async throws
}
