//
//  View+extensions.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 15.01.2024.
//

import SwiftUI

extension View {
    var withSelectedTextInTextField: some View {
        self
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                if let textField = obj.object as? UITextField {
                    textField.selectAll(nil)
                }
            }
    }
}
