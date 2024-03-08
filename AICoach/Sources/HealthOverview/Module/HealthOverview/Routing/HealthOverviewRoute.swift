//  
//  HealthOverviewRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct HealthOverviewRoute: Route {
    let navigator: Navigator
    let input: HealthOverviewInput
    let output: HealthOverviewOutputBlock

    var view: AnyView {
        HealthOverviewScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: HealthOverviewViewModel {
        let router = HealthOverviewRouter(navigator: navigator)
        let viewModel = HealthOverviewViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
