//  
//  MessageRunServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import MunicornFoundation
import Dependencies
import Foundation
import Combine

private let draftMessageKey = "draftMessageKey"

class MessageRunServiceImpl: MessageRunService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.coachApi) private var coachApi
    @Dependency(\.coachMessageService) private var coachMessageService
    @Dependency(\.trackerService) private var trackerService
    private var timer: Timer?
    private var currentTask: Task<Void, Error>?
    private let draftMessageSubject = CurrentValueSubject<CoachMessage?, Never>(nil)

    init() {
        setIsRunning()
    }

    var isRunningPublisher: AnyPublisher<Bool, Never> {
        draftMessageSubject
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    func observeResponse(for message: CoachMessage) {
        cloudStorage.draftMessage = message
        setIsRunning()
        currentTask?.cancel()
        let task = Task {
            var delay: Double = 1
            while !Task.isCancelled {
                if let response = try await loadResponse(for: message, delay: delay) {
                    currentTask?.cancel()
                    currentTask = nil
                    let messages = response.asCoachMessages(runId: message.runId)
                    try await coachMessageService.save(messages)
                    cloudStorage.draftMessage = nil
                    setIsRunning()
                    trackerService.track(.messageReceived)
                } else {
                    delay = min(10, delay + 1)
                }
            }
        }
        currentTask = task
    }

    func observeDraftMessage() {
        guard let message = cloudStorage.draftMessage else {
            return
        }
        observeResponse(for: message)
    }

    private func setIsRunning() {
        draftMessageSubject.send(cloudStorage.draftMessage)
    }

    private func loadResponse(for message: CoachMessage, delay: Double) async throws -> CoachMesssagesResponse? {
        try await Task.sleep(seconds: delay)
        let status = try await coachApi.runStatus(runId: message.runId)
        if status.isRunning {
            return nil
        }
        return try await coachApi.messages(request: .init(after: message.id, limit: 20))
    }
}

private extension CoachMesssagesResponse {
    func asCoachMessages(runId: String) -> [CoachMessage] {
        messages.map { message in
                .init(id: message.id,
                      runId: runId,
                      text: message.textContent,
                      sender: .coach,
                      date: .now)
        }
    }
}

private extension CloudStorage {
    var draftMessage: CoachMessage? {
        get {
            let json: String? = get(key: draftMessageKey)
            return try? CoachMessage(json: json ?? "")
        }
        set {
            set(key: draftMessageKey, value: newValue?.json())
        }
    }
}
