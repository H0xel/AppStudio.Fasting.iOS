//  
//  NotificationsForStagesRoute.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct NotificationsForStagesRoute: Route {
    let navigator: Navigator
    let input: NotificationsForStagesInput
    let output: NotificationsForStagesOutputBlock

    var view: AnyView {
        NotificationsForStagesScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: NotificationsForStagesViewModel {
        let router = NotificationsForStagesRouter(navigator: navigator)
        let viewModel = NotificationsForStagesViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
