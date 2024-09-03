//
//  Data.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 09.11.2023.
//

import Foundation

public extension Data {
    var toFormattedPushToken: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}
