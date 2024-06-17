//  
//  PersonalizedPaywallRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import SwiftUI
import AppStudioNavigation

class PersonalizedPaywallRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: PersonalizedPaywallInput,
                      output: @escaping PersonalizedPaywallOutputBlock) -> Route {
        PersonalizedPaywallRoute(navigator: navigator, input: input, output: output)
    }

    func presentProgressView() {
        present(banner: DimmedProgressBanner())
    }

    func open(url: URL) {
        let route = SafariRoute(url: url) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }
}
