//
//  FastingLimitService.swift
//  Fasting
//
//  Created by Denis Khlopin on 24.11.2023.
//

import Foundation

protocol FastingLimitService {
    var isLimited: Bool { get }
    func increaseLimit(by count: Int)
}
