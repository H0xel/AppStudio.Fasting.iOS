//
//  RunStatus.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Foundation

public struct RunStatus: Codable {
    public let runId: String
    public let status: String

    public init(runId: String, status: String) {
        self.runId = runId
        self.status = status
    }

    var isRunning: Bool {
        status == "queued" || status == "in_progress"
    }
}
