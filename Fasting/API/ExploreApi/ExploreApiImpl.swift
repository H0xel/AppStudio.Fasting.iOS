//
//  ExploreApiImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 23.04.2024.
//

import Foundation
import Explore

class ExploreApiImpl: ExploreApi {
    private let provider = TelecomApiProvider<ExploreApiTarget>()

    func list() async throws -> [Explore.ExploreFile] {
        try await provider.request(.files)
    }

    func download(exploreFileName: String) async throws -> Data {
        try await provider.requestData(.download(file: exploreFileName))
    }
}
