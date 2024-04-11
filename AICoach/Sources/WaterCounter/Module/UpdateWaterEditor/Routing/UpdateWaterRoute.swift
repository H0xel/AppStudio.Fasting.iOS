//  
//  UpdateWaterRoute.swift
//  
//
//  Created by Denis Khlopin on 09.04.2024.
//

import SwiftUI
import AppStudioNavigation

public struct UpdateWaterRoute: Route {
    let navigator: Navigator
    let input: UpdateWaterInput
    let output: UpdateWaterOutputBlock

    public init(navigator: Navigator, input: UpdateWaterInput, output: @escaping UpdateWaterOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        UpdateWaterScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: UpdateWaterViewModel {
        let router = UpdateWaterRouter(navigator: navigator)
        let viewModel = UpdateWaterViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
