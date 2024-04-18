//
//  CoachApiImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.04.2024.
//

import Foundation
import AICoach

class CoachApiImpl: CoachApi {

    private let provider = TelecomApiProvider<CoachApiTarget>()

    func messages(request: CoachMessagesRequest) async throws -> CoachMesssagesResponse {
        try await provider.request(.messages(request: request))
    }

    func sendMessage(request: SendMessageRequest) async throws -> SendMessageResponse {
        try await provider.request(.sendMessage(request: request))
    }

    func runStatus(runId: String) async throws -> RunStatus {
        try await provider.request(.runStatus(runId: runId))
    }
}
