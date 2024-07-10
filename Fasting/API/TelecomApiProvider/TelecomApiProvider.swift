//
//  TelecomApiProvider.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation
import Moya
import Dependencies
import AppStudioModels

class TelecomApiProvider<Target: TelecomTargetType> {
    @Dependency(\.trackerService) private var trackerService

    private let provider: MoyaProvider<Target> = {
        var plugins: [PluginType] = [
            AccessTokenPlugin(tokenClosure: { _ in
                @Dependency(\.accountProvider) var accountProvider
                let accountId = accountProvider.accountId
                let accessToken = "AT-\(accountProvider.accessToken)"
                guard let authData = ("\(accountId):\(accessToken)").data(using: .utf8) else {
                    fatalError("Can not create credetials string")
                }
                return authData.base64EncodedString()
            })
        ]
#if DEBUG
        plugins.append(NetworkLoggerPlugin.verbose)
#endif
        return MoyaProvider<Target>(plugins: plugins)
    }()

    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard let date = Date.dateFromISO8601String(dateStr) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date")
            }
            return date
        }
        return decoder
    }()

    func request<T: Codable>(_ target: Target) async throws -> T {
        let decoder = self.decoder
        return try await withUnsafeThrowingContinuation { continuation in
            provider.request(target) { [weak self] result in
                guard let self else {
                    continuation.resume(throwing: TelecomError.unknownError(with: "self is nill"))
                    return
                }
                switch result {
                case .success(let response):
                    do {
                        let filteredReponse = try response.filterSuccessfulStatusCodes()
                        let data = try filteredReponse.map(T.self, using: decoder, failsOnEmptyData: false)
                        continuation.resume(returning: data)
                    } catch MoyaError.statusCode(let response) {
                        let error = self.handleStatusCodes(with: response)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    } catch MoyaError.jsonMapping(let response) {
                        let error = self.handleMappingError(with: response)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    } catch MoyaError.objectMapping(let error, let response) {
                        let error = self.handleMappingError(with: response, error: error)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    } catch {
                        let error = TelecomError.unknownError(with: error.localizedDescription)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    let error = self.handleFailure(with: moyaError)
                    trackError(error, target: target)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func requestData(_ target: Target) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            provider.request(target) { [weak self] result in
                guard let self else {
                    continuation.resume(throwing: TelecomError.unknownError(with: "self is nill"))
                    return
                }
                switch result {
                case .success(let response):
                    do {
                        let filteredReponse = try response.filterSuccessfulStatusCodes()
                        let data = filteredReponse.data
                        continuation.resume(returning: data)
                    } catch MoyaError.statusCode(let response) {
                        let error = self.handleStatusCodes(with: response)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    } catch MoyaError.jsonMapping(let response) {
                        let error = self.handleMappingError(with: response)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    } catch MoyaError.objectMapping(let error, let response) {
                        let error = self.handleMappingError(with: response, error: error)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    } catch {
                        let error = TelecomError.unknownError(with: error.localizedDescription)
                        trackError(error, target: target)
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }

    private func handleFailure(with error: MoyaError) -> TelecomError {
        switch error {
        case .underlying(let error, _):
            guard let afError = error.asAFError else {
                return .unknownError(with: error.localizedDescription)
            }
            if afError.isSessionTaskError {
                return .networkError(with: afError.localizedDescription)
            }
            return .unknownError(with: afError.localizedDescription)
        default:
            return .unknownError(with: error.localizedDescription)
        }
    }

    private func handleStatusCodes(with response: Response) -> TelecomError {
        guard let errorResponse = try? response.map(TelecomApiErrorResponse.self,
                                                    using: decoder, failsOnEmptyData: false) else {
            let body = String(data: response.data, encoding: .utf8) ?? ""
            return .unknownError(with: "HTTP Status Code - \(response.statusCode) - \(body)")
        }
        return errorResponse.error
    }

    private func handleMappingError(with response: Response, error: Error? = nil) -> TelecomError {
        let jsonString = String(data: response.data, encoding: .utf8) ?? "Empty JSON string"
        let errorString = error?.localizedDescription ?? ""
        return .mappingError(with: errorString, jsonString: jsonString)
    }

    private func trackError(_ error: TelecomError, target: Target) {
        trackerService.track(.serverError(code: error.code.rawValue,
                                          message: error.message,
                                          details: error.detail?.message,
                                          traceId: error.traceId,
                                          path: "\(target.method) \(target.path)"))
    }
}

