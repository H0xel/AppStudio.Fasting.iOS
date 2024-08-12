//  
//  BottomActionSheetOutput.swift
//  
//
//  Created by Amakhin Ivan on 10.07.2024.
//
import AppStudioUI

public typealias BottomActionSheetOutputBlock = ViewOutput<BottomActionSheetOutput>

public enum BottomActionSheetOutput {
    case leftButtonTapped
    case rightButtonTapped
}
