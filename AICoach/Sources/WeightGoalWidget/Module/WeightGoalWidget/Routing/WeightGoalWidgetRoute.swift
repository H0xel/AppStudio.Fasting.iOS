//  
//  WeightGoalWidgetRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation

public struct WeightGoalWidgetRoute: Route {
    let navigator: Navigator
    let input: WeightGoalWidgetInput
    let output: WeightGoalWidgetOutputBlock

    public init(navigator: Navigator,
                input: WeightGoalWidgetInput,
                output: @escaping WeightGoalWidgetOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        WeightGoalWidgetScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: WeightGoalWidgetViewModel {
        let router = WeightGoalWidgetRouter(navigator: navigator)
        let viewModel = WeightGoalWidgetViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
