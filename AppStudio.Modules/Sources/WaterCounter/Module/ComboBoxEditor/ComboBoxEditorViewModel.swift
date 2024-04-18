//  
//  ComboBoxEditorViewModel.swift
//  
//
//  Created by Denis Khlopin on 22.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Combine

class ComboBoxEditorViewModel: BaseViewModel<ComboBoxEditorOutput> {
    var router: ComboBoxEditorRouter!

    let title: String
    let values: [ComboBoxValue]
    let buttonTitle: String
    @Published var value: String

    init(input: ComboBoxEditorInput, output: @escaping ComboBoxEditorOutputBlock) {
        self.title = input.title
        self.value = input.value
        self.values = input.values
        self.buttonTitle = input.buttonTitle
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

    func update(value: ComboBoxValue) {
        self.value = value.value
    }
}
