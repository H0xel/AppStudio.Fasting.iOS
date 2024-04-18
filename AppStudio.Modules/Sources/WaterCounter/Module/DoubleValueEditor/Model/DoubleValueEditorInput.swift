//  
//  DoubleValueEditorInput.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//
import AppStudioStyles

struct DoubleValueEditorInput {
    let title: String
    let description: String?
    let predefinedValues: [DoubleValuePredefinedValue]?
    let value: Double
    let unitsTitle: String

    let buttonTitle: String?
    let hasBackButton: Bool
    let textfieldType: UpdateWeightTextfieldType
}
