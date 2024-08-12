//
//  LogProductKeyboardBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 26.07.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct LogProductKeyboardBanner: Banner {

    let input: CustomKeyboardInput
    let output: ViewOutput<LogProductKeyboardOutput>

    var view: AnyView {
        CustomKeyboardScreen(viewModel: viewModel)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            .eraseToAnyView()
    }

    private var viewModel: LogProductKeyboardViewModel {
        let viewModel = LogProductKeyboardViewModel(input: input, output: output)
        return viewModel
    }
}
