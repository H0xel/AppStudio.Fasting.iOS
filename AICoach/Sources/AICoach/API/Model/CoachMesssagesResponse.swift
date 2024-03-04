//
//  ApiMesssagesResponse.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public struct CoachMesssagesResponse: Codable {
    public let firstId: String
    public let lastId: String
    public let hasMore: Bool
    public let messages: [ApiCoachMessage]

    public init(firstId: String, lastId: String, hasMore: Bool, messages: [ApiCoachMessage]) {
        self.firstId = firstId
        self.lastId = lastId
        self.hasMore = hasMore
        self.messages = messages
    }
}
