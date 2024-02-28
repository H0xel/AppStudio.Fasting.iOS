//
//  ApiCoachMessage.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public struct ApiCoachMessage: Codable {
    public let id: String
    public let createdAt: String
    public let role: String
    public let textContent: String

    public init(id: String, createdAt: String, role: String, textContent: String) {
        self.id = id
        self.createdAt = createdAt
        self.role = role
        self.textContent = textContent
    }
}
