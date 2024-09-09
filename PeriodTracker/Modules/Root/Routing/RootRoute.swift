//  
//  RootRoute.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct RootRoute: Route {

    private let viewModel = RootViewModel()

    var view: AnyView {
        RootScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
