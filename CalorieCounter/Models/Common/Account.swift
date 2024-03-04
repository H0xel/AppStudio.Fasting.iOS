//
//  Account.swift
//  AppStudioApi
//
//  Created by Александр Alex on 12.12.17.
//  Copyright © 2017 GetPaid Inc. All rights reserved.
//

import Foundation

struct Account: Codable, Equatable {}

extension Account {
    static var emptyAccount: Account {
        .init()
    }
}
