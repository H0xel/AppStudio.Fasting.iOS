//  
//  NotificationsRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 14.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct NotificationsRoute: Route {
    let navigator: Navigator
    let input: NotificationsInput
    let output: NotificationsOutputBlock

    var view: AnyView {
        NotificationsScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: NotificationsViewModel {
        let router = NotificationsRouter(navigator: navigator)
        let viewModel = NotificationsViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
