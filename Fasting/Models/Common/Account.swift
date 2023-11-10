//
//  Account.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation

struct Account: Codable, Equatable {}

extension Account {
    static var emptyAccount: Account {
        .init()
    }
}
