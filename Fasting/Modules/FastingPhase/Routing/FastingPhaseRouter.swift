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
}
