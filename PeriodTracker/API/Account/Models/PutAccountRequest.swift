//
//  PutAccountRequest.swift
//  SecondPhone
//
//  Created by Konstantin Golenkov on 30.10.2023.
//

import Foundation

struct PutAccountRequest: Codable {
    let isProduction: Bool
    let idfa: String?
    let appsflyerId: String?
    let firebaseId: String?
}
