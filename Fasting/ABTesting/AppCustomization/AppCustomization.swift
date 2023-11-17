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

    //TODO: Протестить на то чтобы в кэше не сохранялось
//    func shouldForceUpdate() async throws -> Bool
}
