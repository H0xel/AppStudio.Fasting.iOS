//
//  SendMessageRequest.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public struct SendMessageRequest: Codable {
    public let userContext: String
    public let message: String

    public init(userContext: String, message: String) {
        self.userContext = userContext
        self.message = message
    }
}
