//  
//  NotificationsForStagesOutput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//
import AppStudioUI

typealias NotificationsForStagesOutputBlock = ViewOutput<NotificationsForStagesOutput>

enum NotificationsForStagesOutput {
    case save([FastingStage])
    case close
}
