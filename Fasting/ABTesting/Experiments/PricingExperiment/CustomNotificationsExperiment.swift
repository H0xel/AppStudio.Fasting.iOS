//
//  CustomNotificationsExperiment.swift
//  Fasting
//
//  Created by Amakhin Ivan on 02.07.2024.
//
//exp_custom_notifications
import AppStudioABTesting
import Dependencies
import AppStudioServices

enum CustomNotificationsVariant: String, Codable {
    case test
    case control
}

class CustomNotificationsExperiment: AppStudioExperimentWithRemoteConfig<CustomNotificationsVariant> {
    init() {
        super.init(experimentName: "exp_custom_notifications", defaultValue: .control)
    }
}
