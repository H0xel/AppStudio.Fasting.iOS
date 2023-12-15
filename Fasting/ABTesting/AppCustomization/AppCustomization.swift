//
//  AppCustomization.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 25.10.2023.
//

import Foundation
import AppStudioABTesting
import RxSwift

protocol AppCustomization {
    var forceUpdateAppVersion: Observable<String> { get }
    var appStoreLink: Observable<String> { get }
    func initialize()
    func closePaywallButtonDelay() async throws -> Int
    func isLongOnboardingEnabled() async throws -> Bool
    // TODO: Протестить на то чтобы в кэше не сохранялось
//    func shouldForceUpdate() async throws -> Bool
}
