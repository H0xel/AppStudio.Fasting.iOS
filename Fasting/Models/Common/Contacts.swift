//
//  Contacts.swift
//  AppStudioApi
//
//  Created by Александр Alex on 16.02.18.
//  Copyright © 2018 GetPaid Inc. All rights reserved.
//

import Foundation

// TODO: remove during implementing connection to backend
/// Represents contacts info.
struct Contacts: Codable, Hashable {
    /// Contacts name.
    let name: String?
    /// Contacts phone.
    let phone: String?
    /// Contacts email.
    let email: String?
    /// Contacts address.
    let address: String?
}

extension Contacts {
    static var empty: Contacts {
        .init(name: nil, phone: nil, email: nil, address: nil)
    }
}
