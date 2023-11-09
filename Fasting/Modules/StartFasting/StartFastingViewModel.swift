//  
//  StartFastingViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class StartFastingViewModel: BaseViewModel<StartFastingOutput> {

    @Published var fastTime: Date
    let title: LocalizedStringKey
    let dateComponents: DatePickerComponents
    let datesRange: ClosedRange<Date>

    var router: StartFastingRouter!

    init(input: StartFastingInput, output: @escaping StartFastingOutputBlock) {
        fastTime = input.initialDate
        title = input.title
        dateComponents = input.datePickerComponents
        datesRange = input.datesRange
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
