//  
//  ComboBoxEditorOutput.swift
//  
//
//  Created by Denis Khlopin on 22.03.2024.
//
import AppStudioUI

typealias ComboBoxEditorOutputBlock = ViewOutput<ComboBoxEditorOutput>

enum ComboBoxEditorOutput {
    case close
    case value(String)
}
