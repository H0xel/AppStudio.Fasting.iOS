//
//  TelecomError.swift
//  SecondPhone
//
//  Created by Konstantin Golenkov on 31.10.2023.
//

import Foundation

public struct TelecomApiErrorResponse: Codable {
    public let error: TelecomError
}

public struct TelecomError: Codable, Error {
    public let code: TelecomErrorCode
    public let message: String
    public let traceId: String?
    public let detail: TelecomApiErrorDetail?
}

public struct TelecomApiErrorDetail: Codable, CustomStringConvertible {
    public let type: String?
    public let title: String?
    public let message: String?
    public let errors: [TelecomApiErrorValidationModel]?

    public var description: String {
        """
        TelecomApiErrorDetail type: \(type ?? "") \n
        title: \(title ?? "") \n
        message: \(message ?? "") \n
        """
    }
}

public struct TelecomApiErrorValidationModel: Codable, CustomStringConvertible {
    let field: String?
    let message: String?

    public var description: String {
        "TelecomApiErrorValidationModel with title: \(field ?? "") and message: \(message ?? "")"
    }
}

public enum TelecomErrorCode: Int, Codable {
    case wrongParams = 1
    case authFailed = 2
    case notFound = 3
    case operationIsNotAllowed = 4
    case internalError = 10
    case noSubscription = 20
    case notEnoughSubscriptionLevel = 21
    case noAvailablePhoneNumbers = 30
    case phoneNumberProvisionAlreadyCompleted = 31
    case mappingError = 998
    case networkError = 999
    case unknown = 1000

    // backend might have new codes in the future
    // swiftlint:disable cyclomatic_complexity
    public init(rawValue: Int) {
        switch rawValue {
        case 1: self = .wrongParams
        case 2: self = .authFailed
        case 3: self = .notFound
        case 4: self = .operationIsNotAllowed
        case 10: self = .internalError
        case 20: self = .noSubscription
        case 21: self = .notEnoughSubscriptionLevel
        case 30: self = .noAvailablePhoneNumbers
        case 31: self = .phoneNumberProvisionAlreadyCompleted
        case 998: self = .mappingError
        case 999: self = .networkError
        default: self = .unknown
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

public extension TelecomError {
    static func unknownError(with description: String) -> TelecomError {
        let detail = TelecomApiErrorDetail(type: "unknown",
                                           title: "Unknown error",
                                           message: description,
                                           errors: nil)

        return TelecomError(code: .unknown,
                               message: description,
                               traceId: nil,
                               detail: detail)
    }

    static func networkError(with description: String) -> TelecomError {
        let detail = TelecomApiErrorDetail(type: "Network",
                                           title: "Network error",
                                           message: description,
                                           errors: nil)

        return TelecomError(code: .networkError,
                               message: description,
                               traceId: nil,
                               detail: detail)
    }

    static func mappingError(with description: String, jsonString: String) -> TelecomError {
        let detail = TelecomApiErrorDetail(type: "mapping",
                                           title: "Mapping error",
                                           message: description + "\nJSON: " + jsonString,
                                           errors: nil)

        return TelecomError(code: .mappingError,
                        message: description,
                        traceId: nil,
                        detail: detail)
    }
}

extension TelecomError: LocalizedError {

    public var errorDescription: String? {
        """
        TelecomError with Code: \(code) \n
        Message: \(message) \n
        TraceId: \(traceId ?? "") \n
        Detail: \(String(describing: detail))
        """
    }
}
