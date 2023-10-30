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

    @Published var fastTime: Date = .now

    var router: StartFastingRouter!

    init(input: StartFastingInput, output: @escaping StartFastingOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    func save() {
        router.dismiss()
    }

    func cancel() {
        router.dismiss()
    }
}
