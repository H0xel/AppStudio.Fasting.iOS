//  
//  FastingOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//
import AppStudioUI
import HealthOverview
import FastingWidget

typealias FastingOutputBlock = ViewOutput<FastingOutput>

enum FastingOutput {
    case pinTapped
    case updateWidget(FastingWidgetState)
}
