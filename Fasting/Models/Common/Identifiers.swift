//
//  Identifiers.swift
//  AppStudioApi
//
//  Created by Aleksandr Shulga on 14.04.2022.
//  Copyright © 2022 GetPaid Inc. All rights reserved.
//

import Foundation

/// Represents identifiers related to device/user/installation.
struct Identifiers: Codable, Equatable {

    /// User unique id related to AppleId.
    let userId: String

    /// Relates to installation .
    let firebaseId: String?

    /// Relates to installation.
    let appsflyerId: String?

    /// User idfa.
    let idfa: String?

    /// User push token.
    let pushToken: String?
}
