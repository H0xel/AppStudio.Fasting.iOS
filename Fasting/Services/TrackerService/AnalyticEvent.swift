//
//  AnalyticEvent.swift
//  Fasting
//
//  Created by Amakhin Ivan on 23.10.2023.
//

import UIKit
import AppStudioAnalytics
import AppStudioServices

enum AnalyticEvent: MirrorEnum {
    case launch(firstTime: Bool, afId: String?)
    case launchFromPush

    case startedExperiment(expName: String, variantId: String)
    case appliedForcedVariant(expName: String, variantId: String)

    case tapClosePaywall(context: PaywallContext)
    case tapSubscribe(context: PaywallContext,
                      productId: String,
                      type: AnalyticEventType,
                      afId: String?)
    case tapRestorePurchases(context: PaywallContext, afId: String?)
    case paywallShown(context: PaywallContext, type: AnalyticEventType, afId: String?)
    // swiftlint:disable enum_case_associated_values_count
    case purchaseFinished(context: PaywallContext,
                          result: String,
                          message: String,
                          productId: String,
                          type: AnalyticEventType,
                          afId: String?)
    // swiftlint:enable enum_case_associated_values_count
    case restoreFinished(context: PaywallContext, result: RestoreResult, afId: String?)
    // MARK: Fasting Inactive Stage
    case tapFastingArticles(article: String)
    case tapFastingStages(stage: String, context: FastingStagesContext)
    case tapUnlockFastingStages

    // Onboarding

    case tapGetStarted
    case fastingScheduleScreenShown
    case allowNotificationsScreenShown
    case tapAllowNotifications
    case pushAccessDialogShown
    case pushAccessAnswered(isGranted: Bool)
    case onboardingFinished(schedule: String, startTime: String)
    // swiftlint:disable enum_case_associated_values_count
    case goalAnswered(loseWeight: Bool,
                      lookBetter: Bool,
                      feelEnergetic: Bool,
                      mentalClarity: Bool,
                      liveLonger: Bool,
                      healthierLifestyle: Bool)
    // swiftlint:enable enum_case_associated_values_count
    case sexAnswered(sex: String)
    case birthdayAnswered(date: String)
    case heightAnswered(height: Double, units: String)
    case startingWeightAnswered(startingWeight: Double, units: String)
    case targetWeightAnswered(targetWeight: Double, units: String)
    case activityLevelAnswered(activityLevel: String)
    case specialEventAnswered(event: String)
    case eventDateAnswered(date: String)

    // FastingSetup

    case scheduleSet(schedule: String, previousSchedule: String, context: ChooseFastingPlanInput.Context)
    case globalTimeSet(startTime: String, schedule: String, context: ChooseFastingPlanInput.Context)
    case tapChangeSchedule(currentSchedule: String, context: ChooseFastingPlanInput.Context)

    // Common
    case tabSwitched(currentTab: String, previousTab: String)

    // Profile
    case tapSupport

    // Fasting cycle
    case tapStartFasting(currentTime: String,
                         startTime: String,
                         timeUntilFast: String,
                         schedule: String,
                         context: String)
    case tapSaveStartFasting(currentTime: String, startTime: String)
    case tapCancelStartFasting
    case fastingStarted(currentTime: String, startTime: String, schedule: String)
    case tapChangeFastingStartTime(context: FastingChangeTimeContext)
    // Fasting start time changed
    case fastingStartTimeChanged(oldEndTime: String,
                                 newStartTime: String,
                                 fastingInitiated: Bool,
                                 context: StartFastingInput.Context)
    case tapChangeFastingEndTime
    case fastingEndTimeChanged(oldEndTime: String, newStartTime: String)
    case tapSchedule(currentSchedule: String, context: String)
    case tapEndFasting(timeFasted: String,
                       startTime: String,
                       currentTime: String,
                       schedule: String,
                       context: String)
    case fastingFinished(timeFasted: String, startTime: String, currentTime: String, schedule: String)
    case dontGiveUpScreenShown
    case tapCancelFasting(context: CancelFastingContext)
    case tapEndFastingEarly

    case tapLogPreviousFast(date: String)
    case tapUpdatePreviousFast(date: String)
    case fastingLogged(timeFasted: String, startTime: String, endTime: String, schedule: String)
    // swiftlint:disable enum_case_associated_values_count
    case fastingUpdated(
        newTimeFasted: String,
        newStartTime: String,
        newEndTime: String,
        oldTimeFasted: String,
        oldStartTime: String,
        oldEndTime: String,
        schedule: String
    )
    // swiftlint:enable enum_case_associated_values_count
    // Quick action
    case tapNeedAssistance
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .launch: return "App launched"
        case .launchFromPush: return "Launch from push"
        case .startedExperiment: return "Experiment started"
        case .appliedForcedVariant: return "Forced variant applied"
        case .tapSubscribe: return "Tap subscribe"
        case .tapClosePaywall: return "Tap close paywall"
        case .tapRestorePurchases: return "Tap restore purchases"
        case .paywallShown: return "Paywall shown"
        case .purchaseFinished: return "Purchase finished"
        case .restoreFinished: return "Restore finished"
        case .tapFastingArticles: return "Tap fasting articles"
        case .tapFastingStages: return "Tap fasting stages"
        case .tapUnlockFastingStages: return "Tap unlock fasting stages"
        case .tapGetStarted: return "Tap get started"
        case .fastingScheduleScreenShown: return "Fasting schedule screen shown"
        case .allowNotificationsScreenShown: return "Allow notifications screen shown"
        case .tapAllowNotifications: return "Tap Allow notifications"
        case .pushAccessDialogShown: return "Push access dialog shown"
        case .pushAccessAnswered: return "Push access answered"
        case .onboardingFinished: return "Onboarding finished"
        case .scheduleSet: return "Schedule set"
        case .globalTimeSet: return "Global start time set"
        case .tapChangeSchedule: return "Tap change schedule"
        case .tabSwitched: return "Tab switched"
        case .tapSupport: return "Tap Support"
        case .tapStartFasting: return "Tap start fasting"
        case .tapSaveStartFasting: return "Tap save start fasting"
        case .tapCancelStartFasting: return "Tap cancel start fasting"
        case .fastingStarted: return "Fasting started"
        case .tapChangeFastingStartTime: return "Tap change fasting start time"
        case .tapChangeFastingEndTime: return "Tap change fasting end time"
        case .fastingEndTimeChanged: return "Fasting end time changed"
        case .fastingStartTimeChanged: return "Fasting start time changed"
        case .tapSchedule: return "Tap schedule"
        case .tapEndFasting: return "Tap end fasting"
        case .fastingFinished: return "Fasting finished"
        case .dontGiveUpScreenShown: return "Dont give up screen shown"
        case .tapCancelFasting: return "Tap cancel end fasting"
        case .tapEndFastingEarly: return "Tap end fasting early"
        case .goalAnswered: return "Goals answered"
        case .sexAnswered: return "Sex answered"
        case .birthdayAnswered: return "Birthday answered"
        case .heightAnswered: return "Height answered"
        case .startingWeightAnswered: return "Starting weight answered"
        case .targetWeightAnswered: return "Target weight answered"
        case .activityLevelAnswered: return "Activity level answered"
        case .specialEventAnswered: return "Special event answered"
        case .eventDateAnswered: return "Event date answered"
        case .tapNeedAssistance: return "Tap need assistance"
        case .tapLogPreviousFast: return "Tap log previous fast"
        case .tapUpdatePreviousFast: return "Tap update previous fast"
        case .fastingLogged: return "Fasting loged"
        case .fastingUpdated: return "Fasting updated"
        }
    }

    var forAppsFlyer: Bool {
        false
    }
}

enum AnalyticEventType: String {
    case main
    case promo
}

enum FastingChangeTimeContext: String {
    case fastingScreen
    case endFasting
}

enum CancelFastingContext: String {
    case dontGiveUp
    case endFasting
}

extension Double: TrackerParam {}
