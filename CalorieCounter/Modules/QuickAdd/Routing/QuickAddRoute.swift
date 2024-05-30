//  
//  QuickAddRoute.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//

import SwiftUI
import AppStudioNavigation

struct QuickAddRoute: Route {
    let navigator: Navigator
    let meal: Meal?
    let output: QuickAddOutputBlock

    var view: AnyView {
        QuickAddView(viewModel: viewModel, isPresented: .constant(true))
            .eraseToAnyView()
    }

    private var viewModel: QuickAddViewModel {
        let router = QuickAddRouter(navigator: navigator)
        let viewModel = QuickAddViewModel(meal: meal, output: output)
        viewModel.router = router
        return viewModel
    }
}
