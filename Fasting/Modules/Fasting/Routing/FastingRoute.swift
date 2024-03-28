//  
//  FastingRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct FastingRoute: Route {

    let viewModel: FastingViewModel

    var view: AnyView {
        FastingScreen(viewModel: viewModel)
            .eraseToAnyView()
    }
}
