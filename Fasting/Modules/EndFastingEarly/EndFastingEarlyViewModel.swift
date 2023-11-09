//  
//  EndFastingEarlyViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 07.11.2023.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import Dependencies

class EndFastingEarlyViewModel: BaseViewModel<EndFastingEarlyOutput> {
    var router: EndFastingEarlyRouter!
    @Published private var fastingPlan: FastingPlan = .beginner
    @Dependency(\.fastingParametersService) private var fastingParametersService

    init(input: EndFastingEarlyInput, output: @escaping EndFastingEarlyOutputBlock) {
        super.init(output: output)
        configurePlan()
    }

    var subtitle: String {
        let start = NSLocalizedString("EndFastingEarlyScreen.fastingTime", comment: "")
        let numberOfHours = Int(fastingPlan.duration / .hour)
        let hours = numberOfHours.plural(locFormsGroup: "EndFastingEarlyScreen.hour",
                                         shouldFormat: true,
                                         bundle: .main)
        return String(format: start, hours)
    }

    func configurePlan() {
        fastingParametersService.fastingIntervalPublisher
            .map(\.plan)
            .assign(to: &$fastingPlan)
    }

    func cancel() {
        router.dismiss()
    }

    func endFasting() {
        output(.end)
    }
}
