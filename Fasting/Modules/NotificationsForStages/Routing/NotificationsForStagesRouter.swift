//  
//  NotificationsForStagesRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioNavigation

class NotificationsForStagesRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: NotificationsForStagesInput,
                      output: @escaping NotificationsForStagesOutputBlock) -> Route {
        NotificationsForStagesRoute(navigator: navigator, input: input, output: output)
    }
}
