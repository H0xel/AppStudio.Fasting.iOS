//  
//  CoachMessageServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Dependencies

class CoachMessageServiceImpl: CoachMessageService {

    @Dependency(\.coachMessageRepository) private var coachMessageRepository
    @Dependency(\.coachApi) private var coachApi

    @discardableResult
    func sendMessage(text: String, userData: AICoachUserData) async throws -> CoachMessage {
        let response = try await coachApi.sendMessage(request: .init(userContext: userData.userContext,
                                                                     message: text))
        let userMessage = CoachMessage(id: response.messageId,
                                       runId: response.runId,
                                       text: text,
                                       sender: .user,
                                       date: .now)
        return try await save(userMessage)
    }

    func messages() async throws -> [CoachMessage] {
        try await coachMessageRepository.messages()
    }

    func save(_ messages: [CoachMessage]) async throws {
        try await coachMessageRepository.save(messages)
    }

    func save(_ message: CoachMessage) async throws -> CoachMessage {
        try await coachMessageRepository.save(message)
    }

    func coachMessageOsberver() -> CoachMessageObserver {
        coachMessageRepository.coachMessageOsberver()
    }

    func deleteAll() async throws {
        try await coachMessageRepository.deleteAll()
    }
}

private extension AICoachUserData {
    var userContext: String {
        let dict = [
            "user_data": [
                "current_weight": currentWeight,
                "goal_weight": goalWeight,
                "height": height,
                "date_of_birth": dateOfBirth.currentLocaleFormatted(with: "YYYY-MM-dd"),
                "sex": sex
            ]
        ]
        return dict.json() ?? ""
    }
}
