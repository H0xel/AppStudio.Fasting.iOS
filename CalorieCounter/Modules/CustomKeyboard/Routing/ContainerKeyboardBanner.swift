//
//  CustomKeyboardBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct ContainerKeyboardBanner: Banner {

    let input: CustomKeyboardInput
    let output: CustomKeyboardOutputBlock

    var view: AnyView {
        CustomKeyboardScreen(viewModel: viewModel)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            .eraseToAnyView()
    }

    private var viewModel: ContainerKeyboardViewModel {
        let viewModel = ContainerKeyboardViewModel(input: input, output: output)
        return viewModel
    }
}
