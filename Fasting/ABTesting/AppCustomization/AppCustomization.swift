//
//  AppCustomization.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//

import Foundation
import AppStudioABTesting

protocol AppCustomization {
    func initialize()
    func shouldForceUpdate() async throws -> Bool
}
