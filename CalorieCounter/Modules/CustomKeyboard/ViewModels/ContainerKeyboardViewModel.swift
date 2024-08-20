//
//  ContainerKeyboardViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.07.2024.
//

import Foundation

class ContainerKeyboardViewModel: CustomKeyboardViewModel<ContainerKeyboardOutput> {
    override init(input: CustomKeyboardInput, output: @escaping CustomKeyboardOutputBlock) {
        super.init(input: input, output: output)
    }

    override var style: CustomKeyboardStyle {
        .container
    }

    override func handle(button: CustomKeyboardButton, result: CustomKeyboardResult) {
        switch button {
        case .delete, .dot, .slash, .number:
            output(.valueChanged(result))
        case .up:
            output(.direction(.up))
        case .down:
            output(.direction(.down))
        case .done:
            output(.add(result))
        case .collapse, .log, .add:
            break
        }
    }

    override func servingChanged(result: CustomKeyboardResult) {
        output(.servingChanged(result))
    }

    override func dismissed(result: CustomKeyboardResult) {
        output(.dismissed(result))
    }
}
