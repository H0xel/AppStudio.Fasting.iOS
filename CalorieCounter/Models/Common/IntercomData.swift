//
//  IntercomData.swift
//  AppStudioApi
//
//  Created by Александр Alex on 19.01.18.
//  Copyright © 2018 GetPaid Inc. All rights reserved.
//

import Foundation

/// Represents IntercomData.
struct IntercomData: Codable, Equatable {
    /// Intercom hash.
    let hash: String
    /// Intercom userId.
    let userId: String
}
