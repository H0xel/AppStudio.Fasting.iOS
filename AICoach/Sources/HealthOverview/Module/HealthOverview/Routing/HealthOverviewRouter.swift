//  
//  HealthOverviewRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioNavigation

class HealthOverviewRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: HealthOverviewInput,
                      output: @escaping HealthOverviewOutputBlock) -> Route {
        HealthOverviewRoute(navigator: navigator, input: input, output: output)
    }
}
