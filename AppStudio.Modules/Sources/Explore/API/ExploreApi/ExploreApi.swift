//
//  ExploreApi.swift
//
//
//  Created by Denis Khlopin on 23.04.2024.
//

import Foundation

public struct ExploreFile: Codable {
    let name: String
    let date: String
}
public protocol ExploreApi {
    func list() async throws -> [ExploreFile]
    func download(exploreFileName: String) async throws -> Data
}
