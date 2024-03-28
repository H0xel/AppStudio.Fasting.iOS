//
//  WeightWidgetRoute.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioModels

public struct WeightWidgetRoute: Route {

    private let date: Date
    private let viewModel: WeightWidgetViewModel

    public init(date: Date, viewModel: WeightWidgetViewModel) {
        self.date = date
        self.viewModel = viewModel
    }

    public var view: AnyView {
        WeightWidgetView(date: date, viewModel: viewModel)
            .eraseToAnyView()
    }
}
