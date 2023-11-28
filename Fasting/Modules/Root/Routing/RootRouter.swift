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
    @Dependency(\.openURL) private var openURL
    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.fastingParametersService) private var fastingParametersService

    private let fastingNavigator = Navigator()
    private let profileNavigator = Navigator()
    private let paywallNavigator = Navigator()

    override init(navigator: Navigator) {
        super.init(navigator: navigator)
    }

    lazy var fastingScreen: some View = {
        let route = FastingRoute(navigator: fastingNavigator,
                                 input: .init(),
                                 output: { _ in })
        return fastingNavigator.initialize(route: route)
    }()

    lazy var profileScreen: some View = {
        let route = ProfileRoute(
            navigator: profileNavigator,
            input: .init(),
            output: { _ in }
        )
        return profileNavigator.initialize(route: route)
    }()

    lazy var paywallScreen: some View = {
        let route = PaywallRoute(navigator: self.paywallNavigator, input: .fromSettings) { _ in }
        return paywallNavigator.initialize(route: route)
    }()

    func presentPaywall() {
        Task {
            await paywallService.presentPaywallIfNeeded(paywallContext: .onboarding, router: self)
        }
    }

    func presentAppStore(_ appLink: String) {
        Task {
            guard let url = URL(string: appLink) else {
                return
            }
            await openURL(url)
        }
    }
}
