//  
//  DiscountPaywallRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI
import AppStudioNavigation

class DiscountPaywallRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: DiscountPaywallInput,
                      output: @escaping DiscountPaywallOutputBlock) -> Route {
        DiscountPaywallRoute(navigator: navigator, input: input, output: output)
    }

    func presentProgressView() {
        present(banner: DimmedProgressBanner())
    }
}
