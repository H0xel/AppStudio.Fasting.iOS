//
//  LogProductKeyboardViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.07.2024.
//

import Foundation
import AppStudioUI

enum LogProductKeyboardOutput {
    case valueChanged(CustomKeyboardResult)
    case dismissed(CustomKeyboardResult)
    case log(CustomKeyboardResult)
    case add(CustomKeyboardResult)
}

class LogProductKeyboardViewModel: CustomKeyboardViewModel<LogProductKeyboardOutput> {

    override init(input: CustomKeyboardInput,
                  output: @escaping ViewOutput<LogProductKeyboardOutput>) {
        super.init(input: input, output: output)
    }

    override var style: CustomKeyboardStyle {
        .logProduct
    }

    override func handle(button: CustomKeyboardButton, result: CustomKeyboardResult) {
        switch button {
        case .delete, .dot, .slash, .number:
            output(.valueChanged(result))
        case .add:
            output(.add(result))
        case .log:
            output(.log(result))
        case .collapse, .up, .down, .done:
            break
        }
    }

    override func servingChanged(result: CustomKeyboardResult) {
        output(.valueChanged(result))
    }

    override func dismissed(result: CustomKeyboardResult) {
        output(.dismissed(result))
    }
}
