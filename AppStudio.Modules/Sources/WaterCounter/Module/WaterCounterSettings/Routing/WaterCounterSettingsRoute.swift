//  
//  WaterCounterSettingsRoute.swift
//  
//
//  Created by Denis Khlopin on 20.03.2024.
//

import SwiftUI
import AppStudioNavigation

public struct WaterCounterSettingsRoute: Route {
    private let navigator: Navigator
    private let output: WaterCounterSettingsOutputBlock

    public init(navigator: Navigator, output: @escaping WaterCounterSettingsOutputBlock) {
        self.navigator = navigator
        self.output = output
    }

    public var view: AnyView {
        WaterCounterSettingsScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: WaterCounterSettingsViewModel {
        let router = WaterCounterSettingsRouter(navigator: navigator)
        let viewModel = WaterCounterSettingsViewModel(output: output)
        viewModel.router = router
        return viewModel
    }
}
