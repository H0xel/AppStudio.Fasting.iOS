//
//  TabBarViewModel.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI
import AppStudioUI

class TabBarViewModel: BaseViewModel<Void> {

    @Published var currentTab: AppTab = .tracker

    private let router = TabBarRouter(navigator: .init())

    lazy var trackerScreen: some View = {
        router.trackerScreen(input: .init(), output: { _ in })
    }()
}
