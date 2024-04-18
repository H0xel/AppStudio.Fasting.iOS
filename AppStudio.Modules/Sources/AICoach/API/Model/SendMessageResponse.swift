//
//  SendMessageResponse.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public struct SendMessageResponse: Codable {
    public let messageId: String
    public let runId: String

    public init(messageId: String, runId: String) {
        self.messageId = messageId
        self.runId = runId
    }
}
