//  
//  UpdateWeightRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI
import AppStudioNavigation

public struct UpdateWeightRoute: Route {
    private let navigator: Navigator
    private let input: UpdateWeightInput
    private let output: UpdateWeightOutputBlock

    public init(navigator: Navigator, input: UpdateWeightInput, output: @escaping UpdateWeightOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        UpdateWeightScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: UpdateWeightViewModel {
        let router = UpdateWeightRouter(navigator: navigator)
        let viewModel = UpdateWeightViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
