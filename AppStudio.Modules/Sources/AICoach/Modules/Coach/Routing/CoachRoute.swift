//  
//  CoachRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioNavigation

public struct CoachRoute: Route {

    private let viewModel: CoachViewModel

    public init(navigator: Navigator,
                input: CoachInput,
                output: @escaping CoachOutputBlock) {
        let router = CoachRouter(navigator: navigator)
        let viewModel = CoachViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    public var view: AnyView {
        CoachScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
