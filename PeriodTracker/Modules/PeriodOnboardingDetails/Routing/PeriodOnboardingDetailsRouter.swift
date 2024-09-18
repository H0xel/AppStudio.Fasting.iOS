//  
//  PeriodOnboardingDetailsRouter.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 16.09.2024.
//

import SwiftUI
import AppStudioNavigation

class PeriodOnboardingDetailsRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: PeriodOnboardingDetailsInput,
                      output: @escaping PeriodOnboardingDetailsOutputBlock) -> Route {
        PeriodOnboardingDetailsRoute(navigator: navigator, input: input, output: output)
    }
}
