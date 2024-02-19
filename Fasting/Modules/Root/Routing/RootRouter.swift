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

    func fastingScreen(output: @escaping FastingOutputBlock) -> some View  {
        let route = FastingRoute(navigator: fastingNavigator,
                                 input: .init(),
                                 output: output)
        return fastingNavigator.initialize(route: route)
    }

    lazy var profileScreen: some View = {
        let route = ProfileRoute(
            navigator: profileNavigator,
            input: .init(),
            output: { _ in }
        )
        return profileNavigator.initialize(route: route)
    }()

    lazy var paywallScreen: some View = {
        let route = PaywallRoute(navigator: paywallNavigator, input: .fromSettings) { _ in }
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

    func presentSupport() {
        guard EmailRoute.canPresent else {
            sendEmailWithOpenUrl()
            return
        }
        let subject = NSLocalizedString("ProfileScreen.supportEmailSubject", comment: "")
        let route = EmailRoute(recipient: GlobalConstants.contactEmail, subject: subject) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }

    private func sendEmailWithOpenUrl() {
        Task {
            guard let url = URL(string: GlobalConstants.contactEmail) else { return }
            await openURL(url)
        }
    }

}
