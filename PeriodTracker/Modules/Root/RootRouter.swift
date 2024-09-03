//  
//  RootRouter.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class RootRouter: BaseRouter {
    @Dependency(\.openURL) private var openURL

    func presentPaywall() {}

    func presentAppStore() {
        Task {
            guard let url = URL(string: GlobalConstants.appStoreURL) else {
                return
            }
            await openURL(url)
        }
    }
}
