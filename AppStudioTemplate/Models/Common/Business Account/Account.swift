//
//  Account.swift
//  AppStudioApi
//
//  Created by Александр Alex on 12.12.17.
//  Copyright © 2017 GetPaid Inc. All rights reserved.
//

import Foundation

// TODO: update during implementing connection to backend
/// Represents bussines account stored on backend.
struct Account: Codable, Equatable {
    /// Account version.
    let version: Int
    /// Account businessName.
    let businessName: String?
    /// Account contacts.
    let contacts: Contacts
    /// IntercomData.
    let intercom: IntercomData?

    init(version: Int, businessName: String?, contacts: Contacts, intercom: IntercomData? = nil) {
        self.version = version
        self.businessName = businessName
        self.contacts = contacts
        self.intercom = intercom
    }
}

extension Account {
    static var emptyAccount: Account {
        .init(version: 0,
              businessName: nil,
              contacts: Contacts.empty)
    }
}
