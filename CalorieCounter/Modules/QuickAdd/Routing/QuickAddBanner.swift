//
//  QuickAddBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 03.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct QuickAddBanner: Banner {
    let navigator: Navigator
    let input: QuickAddInput
    let output: QuickAddOutputBlock

    var view: AnyView {
        QuickAddView(viewModel: viewModel)
            .transition(.push(from: .bottom))
            .eraseToAnyView()
    }

    private var viewModel: QuickAddViewModel {
        let router = QuickAddRouter(navigator: navigator)
        let viewModel = QuickAddViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
