//  
//  FastingHealthProgressRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI
import AppStudioNavigation
import Combine

public struct FastingHealthProgressRoute: Route {
    let navigator: Navigator
    let inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>
    let output: HealthProgressOutputBlock

    public init(navigator: Navigator,
                inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>,
                output: @escaping HealthProgressOutputBlock) {
        self.navigator = navigator
        self.inputPublisher = inputPublisher
        self.output = output
    }

    public var view: AnyView {
        FastingHealthProgressScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: HealthProgressViewModel {
        let router = HealthProgressRouter(navigator: navigator)
        let viewModel = HealthProgressViewModel(inputPublisher: inputPublisher, output: output)
        viewModel.router = router
        return viewModel
    }
}
