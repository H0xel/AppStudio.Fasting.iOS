//
//  IdentifiersSyncService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 23.06.2023.
//

import Foundation

protocol IdentifiersSyncService {
    @discardableResult
    func sync(isForce: Bool) async throws -> Identifiers?
}
