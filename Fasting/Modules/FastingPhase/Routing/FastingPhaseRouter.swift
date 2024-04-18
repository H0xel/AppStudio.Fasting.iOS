//  
//  FastingPhaseRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class FastingPhaseRouter: BaseRouter {
    func presentPaywall(output: @escaping ViewOutput<PaywallScreenOutput>) {
        let route = PaywallRoute(navigator: navigator, input: .fastingStages, output: output)
        present(route: route)
    }

    func presentMultipleProductPaywall() {
        let route = MultiplePaywallRoute(navigator: navigator,
                                         input: .init(paywallContext: .fastingStages),
                                         output: { [weak self] output in
            switch output {
            case .close, .subscribed:
                self?.navigator.dismiss()
            }
        })
        navigator.present(route: route)
    }
}
