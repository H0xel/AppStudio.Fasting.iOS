//  
//  NotificationOnboardingRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

class NotificationOnboardingRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: NotificationOnboardingInput,
                      output: @escaping NotificationOnboardingOutputBlock) -> Route {
        NotificationOnboardingRoute(navigator: navigator, input: input, output: output)
    }
}
