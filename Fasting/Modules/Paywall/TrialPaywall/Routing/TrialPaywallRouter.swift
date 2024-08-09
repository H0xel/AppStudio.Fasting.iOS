//  
//  TrialPaywallRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 05.08.2024.
//

import SwiftUI
import AppStudioNavigation

class TrialPaywallRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: TrialPaywallInput,
                      output: @escaping TrialPaywallOutputBlock) -> Route {
        TrialPaywallRoute(navigator: navigator, input: input, output: output)
    }

    func presentProgressView() {
        present(banner: DimmedProgressBanner())
    }
}
