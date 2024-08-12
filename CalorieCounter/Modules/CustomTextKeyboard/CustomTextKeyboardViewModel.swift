//  
//  CustomTextKeyboardViewModel.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.07.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI

class CustomTextKeyboardViewModel: BaseViewModel<CustomTextKeyboardOutput> {
    var router: CustomTextKeyboardRouter!
    @Published var isTextSelected: Bool
    @Published var text: String
    private let initialText: String
    let title: String

    init(input: CustomTextKeyboardInput, output: @escaping CustomTextKeyboardOutputBlock) {
        title = input.title
        text = input.text
        initialText = input.text
        isTextSelected = true
        super.init(output: output)
        subscribeToTextChanges()
    }

    func nextButtonTapped() {
        output(.nextButtonTapped)
    }

    private func subscribeToTextChanges() {
        $text
            .removeDuplicates()
            .sink(with: self) { this, inputText in
                this.output(.textChanged(inputText))
            }
            .store(in: &cancellables)
    }
}
