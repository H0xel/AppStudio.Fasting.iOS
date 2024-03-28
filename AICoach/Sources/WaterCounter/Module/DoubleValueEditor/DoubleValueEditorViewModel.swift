//  
//  DoubleValueEditorViewModel.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import AppStudioStyles
import Combine

class DoubleValueEditorViewModel: BaseViewModel<DoubleValueEditorOutput> {
    var router: DoubleValueEditorRouter!

    let title: String
    let description: String?
    let predefinedValues: [DoubleValuePredefinedValue]?
    @Published var value: Double = 0
    let unitsTitle: String

    let buttonTitle: String?
    let hasBackButton: Bool
    let textfieldType: UpdateWeightTextfieldType

    init(input: DoubleValueEditorInput, output: @escaping DoubleValueEditorOutputBlock) {
        self.value = input.value
        self.unitsTitle = input.unitsTitle

        self.title = input.title
        self.description = input.description
        self.predefinedValues = input.predefinedValues
        self.buttonTitle = input.buttonTitle
        self.hasBackButton = input.hasBackButton
        self.textfieldType = input.textfieldType

        super.init(output: output)
    }

    func submit() {
        output(.value(value))
        router.dismiss()
    }

    func close() {
        output(.close)
        router.dismiss()
    }

    func update(value: DoubleValuePredefinedValue) {
        self.value = value.value
        output(.onTapPrefferedChips(value.value))
    }
}
