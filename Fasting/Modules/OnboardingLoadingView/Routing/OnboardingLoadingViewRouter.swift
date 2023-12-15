//  
//  OnboardingLoadingViewRouter.swift
//  Fasting
//
//  Created by Denis Khlopin on 07.12.2023.
//

import SwiftUI
import AppStudioNavigation

class OnboardingLoadingViewRouter: BaseRouter {
    static func route(navigator: Navigator,
                      output: @escaping OnboardingLoadingViewOutputBlock) -> Route {
        OnboardingLoadingViewRoute(navigator: navigator, output: output)
    }
}
