//
//  BackendEnvironmentService.swift
//
//
//  Created by Amakhin Ivan on 04.09.2023.
//

import Dependencies
import MunicornFoundation
import Combine
import UIKit

class BackendEnvironmentService: ObservableObject {
    @Published var currentEnvironment: BackendEnvironment = .production
    let environments: [BackendEnvironment] = [.production, .staging]

    @Dependency(\.preferencesService) private var preferencesService
    @Dependency(\.storageService) private var storageService

    init() {
        if !UIDevice.current.isSandbox {
            currentEnvironment = .production
            return
        }
        currentEnvironment = preferencesService.isStagingEnabled ? .staging : self.storageService.environment
    }

    func change(to environment: BackendEnvironment) {
        storageService.environment = environment
        currentEnvironment = environment
    }
}

public enum BackendEnvironment: String {
    case staging
    case production
}

private let backendEnvironmentKey = "Debug.backendEnvironmentKey"
public extension StorageService {

    var environment: BackendEnvironment {
        get {
            if let environment: BackendEnvironment = .init(rawValue: get(
                key: backendEnvironmentKey,
                defaultValue: BackendEnvironment.staging.rawValue)) {
                return environment
            }
            return .production
        }
        set { set(key: backendEnvironmentKey, value: newValue.rawValue) }
    }
}
