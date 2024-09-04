//
//  PeriodTackerRoute.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct PeriodTackerRoute: Route {

    let navigator: Navigator
    let input: PeriodTrackerInput
    let output: ViewOutput<PeriodTrackerOutput>

    var view: AnyView {
        PeriodTrackerScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: PeriodTrackerViewModel {
        let router = PeriodTrackerRouter(navigator: navigator)
        let viewModel = PeriodTrackerViewModel(router: router, input: input, output: output)
        return viewModel
    }
}
