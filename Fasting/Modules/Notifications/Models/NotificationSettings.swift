//
//  NotificationSettings.swift
//  Fasting
//
//  Created by Amakhin Ivan on 19.06.2024.
//

import Foundation
import AppStudioStyles

struct NotificationSettings: Codable {
    var isQuietModeToggled: Bool
    var startToFastToggled: Bool
    var endToFastToggled: Bool
    var advanceRemindersToggled: Bool
    var isFastingStagesToggled: Bool
    var isWeightToggled: Bool
    var isHydrationToggled: Bool
    var quiteModeFromTime: Date
    var quiteModeToTime: Date
    var beforeStartPriorSelection: NotificationPrior
    var beforeEndPriorSelection: NotificationPrior
    var selectedFastingStages: [FastingStage]
    var timeToWeight: Date
    var weightFrequency: WeightFrequency
    var startTimeHydration: Date
    var endTimeHydration: Date
    var hydrationFrequency: HydrationFrequency
}

extension NotificationSettings {
    static var initial: NotificationSettings {
        .init(
            isQuietModeToggled: true,
            startToFastToggled: true,
            endToFastToggled: true,
            advanceRemindersToggled: true,
            isFastingStagesToggled: true,
            isWeightToggled: true,
            isHydrationToggled: true,
            quiteModeFromTime: .setHour(hour: 22),
            quiteModeToTime: .setHour(hour: 8),
            beforeStartPriorSelection: .oneHour,
            beforeEndPriorSelection: .oneHour,
            selectedFastingStages: [.autophagy, .burning],
            timeToWeight: .setHour(hour: 9),
            weightFrequency: .everyDay,
            startTimeHydration: .setHour(hour: 9),
            endTimeHydration: .setHour(hour: 23),
            hydrationFrequency: .everyTwoHours
        )
    }

    static func initial(isLocked: Bool) -> NotificationSettings {
        .init(
            isQuietModeToggled: isLocked ? !isLocked : true,
            startToFastToggled: true,
            endToFastToggled: true,
            advanceRemindersToggled: true,
            isFastingStagesToggled: isLocked ? !isLocked : true,
            isWeightToggled: isLocked ? !isLocked : true,
            isHydrationToggled: isLocked ? !isLocked : true,
            quiteModeFromTime: .setHour(hour: 22),
            quiteModeToTime: .setHour(hour: 8),
            beforeStartPriorSelection: .oneHour,
            beforeEndPriorSelection: .oneHour,
            selectedFastingStages: isLocked ? [] : [.autophagy, .burning],
            timeToWeight: .setHour(hour: 9),
            weightFrequency: .everyDay,
            startTimeHydration: .setHour(hour: 9),
            endTimeHydration: .setHour(hour: 23),
            hydrationFrequency: .everyTwoHours
        )
    }
}
