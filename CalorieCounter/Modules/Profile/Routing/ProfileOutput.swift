//  
//  ProfileOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//
import AppStudioUI

typealias ProfileOutputBlock = ViewOutput<ProfileOutput>

enum ProfileOutput {
    case updateProfile
    case switchTabBar(isHidden: Bool)
}
