//  
//  ComboBoxEditorInput.swift
//  
//
//  Created by Denis Khlopin on 22.03.2024.
//

struct ComboBoxEditorInput {
    let title: String
    let values: [ComboBoxValue]
    let value: String
    let buttonTitle: String
}

struct ComboBoxValue: Hashable {
    let title: String
    let value: String
}
