//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Foundation
import AppStudioAnalytics
import MunicornFoundation
import Dependencies

public class AICoachInitializer {

    @Dependency(\.messageRunService) private var messageRunService
    @Dependency(\.coachService) private var coachService
    @Dependency(\.coachMessageService) private var coachMessageService

    public init() {}

    public func initialize(styles: CoachStyles,
                           coachApi: CoachApi) {
        CoachStylesKey.liveValue = styles
        CoachApiKey.liveValue = coachApi
        messageRunService.observeDraftMessage()
        configureInitialMessages()
    }

    private func configureInitialMessages() {
        guard !coachService.isInitialized else {
            return
        }
        Task {
            _ = try await coachMessageService.save(.initialMessageTermsAgree)
            coachService.setAsInitialized()
        }
    }
}
