//  
//  WeightGoalUpdateRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation

struct WeightGoalUpdateRoute: Route {
    let navigator: Navigator
    let input: WeightGoalUpdateInput
    let output: WeightGoalUpdateOutputBlock

    var view: AnyView {
        WeightGoalUpdateScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: WeightGoalUpdateViewModel {
        let router = WeightGoalUpdateRouter(navigator: navigator)
        let viewModel = WeightGoalUpdateViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
