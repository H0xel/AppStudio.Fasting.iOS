//  
//  HealthOverviewRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioNavigation

public struct HealthOverviewRoute: Route {
    let navigator: Navigator
    let input: HealthOverviewInput
    let output: HealthOverviewOutputBlock

    public init(navigator: Navigator,
                input: HealthOverviewInput,
                output: @escaping HealthOverviewOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        HealthOverviewScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: HealthOverviewViewModel {
        let router = HealthOverviewRouter(navigator: navigator)
        let viewModel = HealthOverviewViewModel(router: router, input: input, output: output)
        return viewModel
    }
}
