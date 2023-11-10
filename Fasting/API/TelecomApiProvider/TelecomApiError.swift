//
//  TelecomApiError.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation

struct TelecomApiError: Codable {
    let code: TelecomApiErrorCode
    let message: String
    let traceId: String?
    let detail: TelecomApiErrorDetail
}

struct TelecomApiErrorDetail: Codable {
    let type: String
    let title: String
    let message: String?
}

enum TelecomApiErrorCode: Int, Codable {
    case wrongParams = 1
    case authFailed = 2
    case notFound = 3
    case internalError = 10
    case phoneNumberProvisionAlreadyInProgress = 301
    case noAvailablePhoneNumbers = 302
    case phoneNumberProvisionAlreadyCompleted = 303
}
