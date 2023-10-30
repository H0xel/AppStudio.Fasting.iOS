//  
//  RootRouter.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class RootRouter: BaseRouter {
    @Dependency(\.paywallService) private var paywallService
    private let fastingNavigator = Navigator()

    lazy var fastingScreen: some View = {
        let route = FastingRoute(navigator: fastingNavigator, input: .init(), output: { _ in })
        return fastingNavigator.initialize(route: route)
    }()

    func presentPaywall() {
        Task {
            await paywallService.presentPaywallIfNeeded(paywallContext: .onboarding, router: self)
        }
    }
}
