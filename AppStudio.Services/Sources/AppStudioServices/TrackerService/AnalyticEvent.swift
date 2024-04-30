//
//  AnalyticEvent.swift
//  
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case idfaShown(afId: String?)
    case idfaAnswered(isGranted: Bool, afId: String?)
    case launchFromPush
    case notificationTapped(type: DeepLink)


    var name: String {
        switch self {
        case .idfaShown: return "Idfa access dialog shown"
        case .idfaAnswered: return "Idfa access answered"
        case .launchFromPush: return "Launch from push"
        case .notificationTapped: return "Notification tapped"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}
