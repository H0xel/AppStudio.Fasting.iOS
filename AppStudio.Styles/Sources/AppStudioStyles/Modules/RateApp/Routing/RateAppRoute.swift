//  
//  RateAppRoute.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import SwiftUI
import AppStudioNavigation

public struct RateAppRoute: Route {
    let navigator: Navigator
    let input: RateAppInput
    let output: RateAppOutputBlock

    public init(navigator: Navigator, input: RateAppInput, output: @escaping RateAppOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        RateAppScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: RateAppViewModel {
        let router = RateAppRouter(navigator: navigator)
        let viewModel = RateAppViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
