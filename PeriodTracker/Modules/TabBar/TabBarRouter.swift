//
//  TabBarRouter.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class TabBarRouter: BaseRouter {

    private let trackerNavigator = Navigator()

    func trackerScreen(input: PeriodTrackerInput,
                       output: @escaping ViewOutput<PeriodTrackerOutput>) -> some View {
        trackerNavigator.initialize(route: PeriodTackerRoute(navigator: trackerNavigator,
                                                             input: input,
                                                             output: output))
    }
}
