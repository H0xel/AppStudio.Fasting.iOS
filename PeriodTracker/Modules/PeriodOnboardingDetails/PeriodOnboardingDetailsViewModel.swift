//  
//  PeriodOnboardingDetailsViewModel.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 16.09.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation

class PeriodOnboardingDetailsViewModel: BaseViewModel<PeriodOnboardingDetailsOutput> {
    var router: PeriodOnboardingDetailsRouter!
    let cycleStartedDate = Date()
    let ovulationDate = Date()
    let nowDate = Date()

    init(input: PeriodOnboardingDetailsInput, output: @escaping PeriodOnboardingDetailsOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    func prevStep() {
        output(.backTapped)
    }

    func nextStep() {
        output(.nextTapped)
    }
}
