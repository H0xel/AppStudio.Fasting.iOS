//  
//  CustomTextKeyboardOutput.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.07.2024.
//
import AppStudioUI

typealias CustomTextKeyboardOutputBlock = ViewOutput<CustomTextKeyboardOutput>

enum CustomTextKeyboardOutput {
    case nextButtonTapped
    case textChanged(String)
}
