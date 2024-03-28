//  
//  WeightGoalUpdateViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import AppStudioModels

class WeightGoalUpdateViewModel: BaseViewModel<WeightGoalUpdateOutput> {
    var router: WeightGoalUpdateRouter!
    @Published var weight: Double = 0
    let weightUnits: WeightUnit

    init(input: WeightGoalUpdateInput, output: @escaping WeightGoalUpdateOutputBlock) {
        weightUnits = input.weightUnits
        super.init(output: output)
    }

    func save() {
        output(.save(.init(value: weight, units: weightUnits)))
        router.dismiss()
    }
}
