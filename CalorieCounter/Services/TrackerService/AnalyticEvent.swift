//
//  AnalyticEvent.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 23.10.2023.
//

import AppStudioAnalytics

enum AnalyticEvent: MirrorEnum {
    case launch(firstTime: Bool, afId: String?)
    case idfaShown(afId: String?)
    case idfaAnswered(isGranted: Bool, afId: String?)

    case startedExperiment(expName: String, variantId: String)
    case appliedForcedVariant(expName: String, variantId: String)

    case tapClosePaywall(context: PaywallContext)
    case tapSubscribe(context: PaywallContext,
                      productId: String,
                      afId: String?)
    case tapRestorePurchases(context: PaywallContext, afId: String?)
    case paywallShown(context: PaywallContext, afId: String?)
    // swiftlint:disable enum_case_associated_values_count
    case purchaseFinished(context: PaywallContext,
                          result: String,
                          message: String,
                          productId: String,
                          afId: String?)
    // swiftlint:enable enum_case_associated_values_count
    case restoreFinished(context: PaywallContext, result: RestoreResult, afId: String?)

    // Onboarding
    case tapGetStarted
    case allowNotificationsScreenShown
    case tapAllowNotifications
    case pushAccessDialogShown
    case pushAccessAnswered(isGranted: Bool)
    // swiftlint:disable enum_case_associated_values_count
    case onboardingFinished(
        tdee: Double,
        calorieBudget: Double,
        // swiftlint:disable identifier_name
        p: Double,
        f: Double,
        c: Double,
        // swiftlint:enable identifier_name
        goal: String,
        goalRate: Double,
        goalUnits: String
    )
    // swiftlint:enable enum_case_associated_values_count
    case sexAnswered(sex: String)
    case birthdayAnswered(date: String)
    case heightAnswered(height: Double, units: String)
    case startingWeightAnswered(startingWeight: Double, units: String, context: OnboardingContext)
    case targetWeightAnswered(targetWeight: Double, units: String, context: OnboardingContext)
    case activityLevelAnswered(activityLevel: String, context: OnboardingContext)
    case specialEventAnswered(event: String)
    case eventDateAnswered(date: String)
    case exerciseFrequencyAnswered(excerciseFrequency: String, context: OnboardingContext)
    case trainingTypeAnswered(trainingType: String, context: OnboardingContext)
    case goalAnswered(goal: String, context: OnboardingContext)
    // swiftlint:disable enum_case_associated_values_count
    case goalRateAnswered(goalRate: Double,
                          units: String,
                          achievementDate: String,
                          calorieBudget: Double,
                          context: OnboardingContext)
    // swiftlint:enable enum_case_associated_values_count
    case tdeeShown(tdee: Double)
    case preferredDietAnswered(diet: String, context: OnboardingContext)
    case proteinLevelAnswered(proteinLevel: String, context: OnboardingContext)
    // swiftlint:disable enum_case_associated_values_count
    case dietPlanShown(
        tdee: Double,
        goal: String,
        calorieBudget: Double,
        // swiftlint:disable identifier_name
        p: Double,
        f: Double,
        c: Double,
        // swiftlint:enable identifier_name
        achievementDate: String,
        proteinLevel: String,
        diet: String,
        context: OnboardingContext
    )
    // swiftlint:enable enum_case_associated_values_count

    // Quick action
    case tapNeedAssistance
    case tabSwitched(currentTab: String, previousTab: String)

    // MARK: - Profile Screen
    case tapSupport
    case tapPlanDetails
    case tapChangePlan
    case tapChangeSex
    case sexChanged
    case tapChangeBirthdayDate
    case birthdayChanged
    case tapChangeHeight
    case heightChanged

    // MARK: - Food Screen
    case tapDate(date: String)
    case swipeWeek(direction: String)
    case tapOpenContainer(container: String)
    case tapAddToContainer(container: String, context: String)
    case tapQuickEntry(container: String)
    case tapScanBarcode(context: String)
    case tapPlus

    // MARK: - FoodLog Screen
    case containerSwitched(currentContainer: String, previousContainer: String)
    case entrySent
    case mealAdded(ingredientsCounts: Int)
    case barcodeScanned(result: String, productName: String?)
    case tapFinishLogging
    case tapBackToFoodLog
    case tapChangeWeight(context: WeightChangeContext)
    case weightChanged(currentWeight: Double, previousWeight: Double, context: WeightChangeContext)
    case elementChosen(context: WeightChangeContext)
    case elementDeleted(context: WeightChangeContext)
}

extension AnalyticEvent {
    var name: String {
        switch self {
        case .launch: return "App launched"
        case .idfaShown: return "Idfa access dialog shown"
        case .idfaAnswered: return "Idfa access answered"
        case .startedExperiment: return "Experiment started"
        case .appliedForcedVariant: return "Forced variant applied"
        case .tapSubscribe: return "Tap subscribe"
        case .tapClosePaywall: return "Tap close paywall"
        case .tapRestorePurchases: return "Tap restore purchases"
        case .paywallShown: return "Paywall shown"
        case .purchaseFinished: return "Purchase finished"
        case .restoreFinished: return "Restore finished"
        case .tapGetStarted: return "Tap get started"
        case .allowNotificationsScreenShown: return "Allow notifications screen shown"
        case .tapAllowNotifications: return "Tap Allow notifications"
        case .pushAccessDialogShown: return "Push access dialog shown"
        case .pushAccessAnswered: return "Push access answered"
        case .onboardingFinished: return "Onboarding finished"
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
        case .exerciseFrequencyAnswered: return "Exercise frequency answered"
        case .trainingTypeAnswered: return "Training type answered"
        case .goalRateAnswered: return "Goal rate answered"
        case .tdeeShown: return "TDEE shown"
        case .preferredDietAnswered: return "Preferred diet answered"
        case .proteinLevelAnswered: return "Protein level answered"
        case .dietPlanShown: return "Diet plan shown"
        case .tabSwitched: return "Tab switched"
        case .tapSupport: return "Tap Support"
        case .tapPlanDetails: return "Tap plan details"
        case .tapChangePlan: return "Tap change plan"
        case .tapChangeSex: return "Tap change sex"
        case .sexChanged: return "Sex changed"
        case .tapChangeBirthdayDate: return "Tap change birthday date"
        case .birthdayChanged: return "Birthday changed"
        case .tapChangeHeight: return "Tap change height"
        case .heightChanged: return "Height changed"
        case .tapDate: return "Tap date"
        case .swipeWeek: return "Swipe week"
        case .tapOpenContainer: return "Tap open container"
        case .tapAddToContainer: return "Tap add to container"
        case .tapQuickEntry: return "Tap quick entry"
        case .tapScanBarcode: return "Tap scan barcode"
        case .tapPlus: return "Tap plus"
        case .containerSwitched: return "Container switched"
        case .entrySent: return "Entry sent"
        case .mealAdded: return "Meal added"
        case .barcodeScanned: return "Barcode scanned"
        case .tapFinishLogging: return "Tap finish logging"
        case .tapBackToFoodLog: return "Tap back to food log"
        case .tapChangeWeight: return "Tap change weight"
        case .weightChanged: return "Weight changed"
        case .elementChosen: return "Element chosen"
        case .elementDeleted: return "Element deleted"
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
