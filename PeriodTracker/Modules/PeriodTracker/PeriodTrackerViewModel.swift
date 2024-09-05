//
//  PeriodTrackerViewModel.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import Foundation
import AppStudioUI

class PeriodTrackerViewModel: BaseViewModel<PeriodTrackerOutput> {

    private let router: PeriodTrackerRouter

    init(router: PeriodTrackerRouter,
         input: PeriodTrackerInput,
         output: @escaping ViewOutput<PeriodTrackerOutput>) {
        self.router = router
        super.init(output: output)
    }
}
