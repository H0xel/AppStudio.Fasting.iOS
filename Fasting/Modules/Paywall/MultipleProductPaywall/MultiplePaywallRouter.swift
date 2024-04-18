//  
//  MultiplePaywallRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 11.04.2024.
//

import SwiftUI
import AppStudioNavigation

class MultiplePaywallRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: MultiplePaywallInput,
                      output: @escaping MultiplePaywallOutputBlock) -> Route {
        MultiplePaywallRoute(navigator: navigator, input: input, output: output)
    }

    func presentProgressView() {
        present(banner: DimmedProgressBanner())
    }
}
