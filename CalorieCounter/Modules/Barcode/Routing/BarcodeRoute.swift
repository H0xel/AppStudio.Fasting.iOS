//  
//  BarcodeRoute.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 28.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct BarcodeRoute: Route {

    let navigator: Navigator
    let input: BarcodeInput
    let output: BarcodeOutputBlock
    
    var view: AnyView {
        BarcodeScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: BarcodeViewModel {
        let router = BarcodeRouter(navigator: navigator)
        let viewModel = BarcodeViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
