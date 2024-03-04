//  
//  DailyCalorieBudgetRoute.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct DailyCalorieBudgetRoute: Route {
    
    let navigator: Navigator
    let mode: DailyCalorieBudgetScreenMode
    let input: DailyCalorieBudgetInput
    let output: DailyCalorieBudgetOutputBlock
    
    var view: AnyView {
        DailyCalorieBudgetScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    private var viewModel: DailyCalorieBudgetViewModel {
        let router = DailyCalorieBudgetRouter(navigator: navigator)
        let viewModel = DailyCalorieBudgetViewModel(mode: mode, input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
