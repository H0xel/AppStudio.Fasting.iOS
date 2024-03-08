//  
//  HealthOverviewViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import AppStudioNavigation
import AppStudioUI

class HealthOverviewViewModel: BaseViewModel<HealthOverviewOutput> {
    var router: HealthOverviewRouter!

    init(input: HealthOverviewInput, output: @escaping HealthOverviewOutputBlock) {
        super.init(output: output)
        // initialization code here
    }
}
