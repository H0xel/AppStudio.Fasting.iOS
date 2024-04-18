//  
//  DoubleValueEditorOutput.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//
import AppStudioUI

typealias DoubleValueEditorOutputBlock = ViewOutput<DoubleValueEditorOutput>

enum DoubleValueEditorOutput {
    // add Output parameters here
    case close
    case value(Double)
    case onTapPrefferedChips(Double)
}
