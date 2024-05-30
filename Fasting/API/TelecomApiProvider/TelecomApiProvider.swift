//
//  TelecomApiProvider.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation
import Moya
import Dependencies

class TelecomApiProvider<Target: TelecomTargetType> {

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
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let filteredReponse = try response.filterSuccessfulStatusCodes()
                        let data = try filteredReponse.map(T.self, using: decoder, failsOnEmptyData: false)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }

    func requestData(_ target: Target) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let filteredReponse = try response.filterSuccessfulStatusCodes()
                        let data = filteredReponse.data
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
}
