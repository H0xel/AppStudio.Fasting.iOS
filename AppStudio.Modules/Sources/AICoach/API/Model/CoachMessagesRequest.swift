//
//  CoachMessagesRequest.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public struct CoachMessagesRequest: Codable {
    public let after: String
    public let limit: Int

    public init(after: String, limit: Int) {
        self.after = after
        self.limit = limit
    }
}
