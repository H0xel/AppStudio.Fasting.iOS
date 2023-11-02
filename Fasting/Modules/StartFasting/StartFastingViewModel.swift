//  
//  StartFastingViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import Foundation
import AppStudioNavigation
import AppStudioUI

class StartFastingViewModel: BaseViewModel<StartFastingOutput> {

    @Published var fastTime: Date

    var router: StartFastingRouter!

    init(input: StartFastingInput, output: @escaping StartFastingOutputBlock) {
        fastTime = input.initialDate
        super.init(output: output)
    }

    func save() {
        output(.save(fastTime))
        router.dismiss()
    }

    func cancel() {
        router.dismiss()
    }
}
