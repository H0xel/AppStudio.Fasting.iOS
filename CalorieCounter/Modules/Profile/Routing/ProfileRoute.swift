//  
//  ProfileRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct ProfileRoute: Route {

    private let viewModel: ProfileViewModel

    init(navigator: Navigator,
         input: ProfileInput,
         output: @escaping ProfileOutputBlock) {

        let router = ProfileRouter(navigator: navigator)
        let viewModel = ProfileViewModel(input: input, output: output)
        viewModel.router = router
        self.viewModel = viewModel
    }

    var view: AnyView {
        ProfileScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
