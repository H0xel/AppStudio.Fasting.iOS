//
//  CoachApi.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public protocol CoachApi {
    func messages(request: CoachMessagesRequest) async throws -> CoachMesssagesResponse
    func sendMessage(request: SendMessageRequest) async throws -> SendMessageResponse
    func runStatus(runId: String) async throws -> RunStatus
}
