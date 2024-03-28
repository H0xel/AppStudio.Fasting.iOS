//
//  AnalyticEvent.swift
//
//
//  Created by
//

import Foundation
import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case drinkAdded(volume: String, context: String)
    case tapVolumeChip(volume: String, context: String)
    case tapAddPreferredVolume(date: String, volume: String)
    case tapRemovePreferredVolume(date: String, volume: String)
    case tapAddCustomVolume(date: String, volume: String)
    case tapWaterSettings(context: String)
    case tapChangeWaterGoal
    case waterGoalUpdated(oldGoal: String, newGoal: String)
    case tapChangePreferredVolume
    case preferredVolumeUpdated(volume: String)
    case tapChangeWaterUnits
    case waterUnitsUpdated(newUnits: String)
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .drinkAdded: "Drink Added"
        case .tapVolumeChip: "Tap volume chip"
        case .tapAddPreferredVolume: "Tap add preferred volume"
        case .tapRemovePreferredVolume: "Tap remove preferred volume"
        case .tapAddCustomVolume: "Tap add custom volume"
        case .tapWaterSettings: "Tap water settings"
        case .tapChangeWaterGoal: "Tap change water goal"
        case .waterGoalUpdated: "Water goal updated"
        case .tapChangePreferredVolume: "Tap change preferred volume"
        case .preferredVolumeUpdated: "Preferred volume updated"
        case .tapChangeWaterUnits: "Tap change water units"
        case .waterUnitsUpdated: "Water units updated"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}

