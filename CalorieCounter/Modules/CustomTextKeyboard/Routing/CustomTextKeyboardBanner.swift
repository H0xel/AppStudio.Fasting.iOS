//
//  CustomTextKeyboardBanner.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.07.2024.
//

import AppStudioNavigation
import SwiftUI

struct CustomTextKeyboardBanner: Banner {
    let input: CustomTextKeyboardInput
    let output: CustomTextKeyboardOutputBlock

    var view: AnyView {
        CustomTextKeyboardScreen(viewModel: viewModel)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            .eraseToAnyView()
    }

    private var viewModel: CustomTextKeyboardViewModel {
        let viewModel = CustomTextKeyboardViewModel(input: input, output: output)
        return viewModel
    }
}
