//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Foundation
import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case tapAgreeToTerms
    case tapMoreSuggestedQuestions
    case tapSuggestedQuestion(question: String, context: String)
    case tapCloseSuggestPanel
    case tapOpenSuggestPanel
    case messageSent
    case messageReceived
    case tapScrollToBottom
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .tapAgreeToTerms: "Tap agree to terms"
        case .tapMoreSuggestedQuestions: "Tap more suggested questions"
        case .tapSuggestedQuestion: "Tap suggested question"
        case .tapCloseSuggestPanel: "Tap close suggest panel"
        case .tapOpenSuggestPanel: "Tap open suggest panel"
        case .messageSent: "Message sent"
        case .messageReceived: "Message received"
        case .tapScrollToBottom: "Tap scroll to bottom"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}
