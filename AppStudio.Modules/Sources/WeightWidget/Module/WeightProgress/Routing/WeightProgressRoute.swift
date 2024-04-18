//  
//  WeightProgressRoute.swift
//  FastingTests
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import AppStudioNavigation

@available(iOS 17.0, *)
public struct WeightProgressRoute: Route {
    private let navigator: Navigator
    private let input: WeightProgressInput
    private let output: WeightProgressOutputBlock

    public init(navigator: Navigator, input: WeightProgressInput, output: @escaping WeightProgressOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        WeightProgressScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: WeightProgressViewModel {
        let router = WeightProgressRouter(navigator: navigator)
        let viewModel = WeightProgressViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
