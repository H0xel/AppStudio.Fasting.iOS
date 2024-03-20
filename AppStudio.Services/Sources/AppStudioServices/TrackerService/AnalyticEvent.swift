//
//  File.swift
//  
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case idfaShown(afId: String?)
    case idfaAnswered(isGranted: Bool, afId: String?)


    var name: String {
        switch self {
        case .idfaShown: return "Idfa access dialog shown"
        case .idfaAnswered: return "Idfa access answered"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}
