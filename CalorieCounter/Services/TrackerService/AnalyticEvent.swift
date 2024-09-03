//
//  AnalyticEvent.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 23.10.2023.
//

import AppStudioAnalytics
import AppStudioServices

// swiftlint:disable enum_case_associated_values_count
enum AnalyticEvent: MirrorEnum {
    case launch(firstTime: Bool, afId: String?)

    case startedExperiment(expName: String, variantId: String)
    case appliedForcedVariant(expName: String, variantId: String)

    case tapClosePaywall(context: PaywallContext)
    case tapSubscribe(context: PaywallContext,
                      productId: String,
                      afId: String?)
    case tapRestorePurchases(context: PaywallContext, afId: String?)
    case paywallShown(context: PaywallContext, afId: String?)
    case purchaseFinished(context: PaywallContext,
                          result: String,
                          message: String,
                          productId: String,
                          afId: String?)
    case restoreFinished(context: PaywallContext, result: RestoreResult, afId: String?)

    // Onboarding
    case tapGetStarted
    case allowNotificationsScreenShown
    case tapAllowNotifications
    case pushAccessDialogShown
    case pushAccessAnswered(isGranted: Bool)
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
    case goalRateAnswered(goalRate: Double,
                          units: String,
                          achievementDate: String,
                          calorieBudget: Double,
                          context: OnboardingContext)
    case tdeeShown(tdee: Double)
    case preferredDietAnswered(diet: String, context: OnboardingContext)
    case proteinLevelAnswered(proteinLevel: String, context: OnboardingContext)
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

    case afFirstSubscribe

    case tapLike
    case tapDislike
    case mealFeedbackSent(type: String, name: String, calories: String, carbs: String,
                          fat: String, protein: String, ingredients: String)
    case feedbackSent(rating: String, feedback: String)

    case tapNextDay(targetDate: String)
    case tapPreviousDay(targetDate: String)

    case remoteConfigProductIsEmpty
    case rateUsDialogShown
    case rateUsDialogAnswered(rate: Int)

    case serverError(code: Int, message: String, details: String?, traceId: String?, path: String)
    case nutritionError(context: String)
}
// swiftlint:enable enum_case_associated_values_count

extension AnalyticEvent {
    var name: String {
        switch self {
        case .launch: return "App launched"
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
        case .afFirstSubscribe: return "af_first_subscribe"
        case .tapLike: return "Tap like"
        case .tapDislike: return "Tap dislike"
        case .mealFeedbackSent: return "Meal feedback sent"
        case .feedbackSent: return "Feedback sent"
        case .tapNextDay: return "Tap next day"
        case .tapPreviousDay: return "Tap previous day"
        case .remoteConfigProductIsEmpty: return "Remote config products is empty"
        case .rateUsDialogShown: return "Rate Us dialog shown"
        case .rateUsDialogAnswered: return "Rate Us dialog answered"
        case .serverError: return "Server error"
        case .nutritionError: return "Nutrition error"
        }
    }

    var forAppsFlyer: Bool {
        switch self {
        case .afFirstSubscribe: true
        default: false
        }
    }
}

enum AnalyticEventType: String {
    case main
    case promo
}
