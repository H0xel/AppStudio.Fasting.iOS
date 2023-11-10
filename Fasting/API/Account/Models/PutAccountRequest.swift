//
//  PutAccountRequest.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation

struct PutAccountRequest: Codable {
    let isProduction: Bool
    let idfa: String?
    let appsflyerId: String?
    let firebaseId: String?
}
