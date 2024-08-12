//  
//  BottomActionSheetRoute.swift
//  
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import SwiftUI
import AppStudioNavigation

public struct BottomActionSheetRoute: Route {
    let navigator: Navigator
    let input: BottomActionSheetInput
    let output: BottomActionSheetOutputBlock

    public init(navigator: Navigator, 
                input: BottomActionSheetInput,
                output: @escaping BottomActionSheetOutputBlock) {
        self.navigator = navigator
        self.input = input
        self.output = output
    }

    public var view: AnyView {
        BottomActionSheetScreen(viewModel: viewModel)
            .eraseToAnyView()
    }

    private var viewModel: BottomActionSheetViewModel {
        let router = BottomActionSheetRouter(navigator: navigator)
        let viewModel = BottomActionSheetViewModel(input: input, output: output)
        viewModel.router = router
        return viewModel
    }
}
