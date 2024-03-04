//  
//  TabBarRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct TabBarRoute: Route {

    private let viewModel: TabBarViewModel

    init(navigator: Navigator,
         input: TabBarInput,
         output: @escaping TabBarOutputBlock) {

        let router = TabBarRouter(navigator: navigator)
        let viewModel = TabBarViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        TabBarScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
