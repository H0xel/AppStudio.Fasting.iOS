//
//  OnboardingServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation
import Dependencies
import AICoach
import WeightWidget
import WeightGoalWidget
import WaterCounter
import AppStudioModels

private let onboardingDataKey = "Fasting.OnboardingDataKey"
private let onboardingCalculatedDataKey = "Fasting.OnboardingCalculatedDataKey"

class OnboardingServiceImpl: OnboardingService, WaterIntakeService {
    var waterUnits: WaterCounter.WaterUnits? {
        guard let data else {
            return nil
        }

        switch data.weight.units {
        case .kg:
            return .liters
        case .lb:
            return .ounces
        }
    }

    var waterIntake: Double? {
        guard let data = calculatedData else {
            return nil
        }

        if data.waterIntake == nil {
            // calculate WaterIntake again for old users
            calculate()
            return calculatedData?.waterIntake
        }
        return data.waterIntake
    }

    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.coachService) private var coachService
    @Dependency(\.weightService) private var weightService
    @Dependency(\.weightGoalService) private var weightGoalService

    var data: OnboardingData? {
        get {
            let json: String? = cloudStorage.get(key: onboardingDataKey)
            return try? OnboardingData(json: json ?? "")
        }
        set { cloudStorage.set(key: onboardingDataKey, value: newValue?.json()) }
    }

    var calculatedData: OnboardingCalculatedData? {
        get {
            let json: String? = cloudStorage.get(key: onboardingCalculatedDataKey)
            return try? OnboardingCalculatedData(json: json ?? "")
        }
        set { cloudStorage.set(key: onboardingCalculatedDataKey, value: newValue?.json()) }
    }

    var paywallInput: PersonalizedPaywallInput? {
        guard let data, let calculatedData else { return nil }

        let sex = data.sex
        let activityLevel = data.activityLevel
        let age = calculatedData.fromAgesTitle
        let weightDifference = WeightMeasure(value: abs(data.weight.value - data.desiredWeight.value),
                                             units: data.weight.units)

        let specialEventDate = data.specialEventDate ?? (data.birthdayDate ?? .now)

        let specialEventWithWeightTitle = data.specialEvent.eventName + " " + (
            calculatedData.specialEventWeight?.wholeValueWithUnits ?? ""
        )

        var status: PersonalizedChart.SpecialEventStatus {
            if data.specialEvent == .noSpecialEvent {
                return .unavailable
            }

            return specialEventDate > calculatedData.desiredWeightDate ? .isLaterThenEndDate : .isEarlierThenEndDate
        }

        return .init(title: calculatedData.paywallTitle,
                     chart: .init(
                        startWeight: data.weight.wholeValueWithUnits,
                        endWeight: data.desiredWeight.wholeValueWithUnits,
                        weightDifference: "- \(weightDifference.wholeValueWithUnits)",
                        endDate: calculatedData.desiredWeightDate.currentLocaleFormatted(with: "MMM dd"),
                        specialEventWithWeightTitle: specialEventWithWeightTitle,
                        specialEventDate: specialEventDate.currentLocaleFormatted(with: "MMM dd"),
                        specialEventStatus: status),
                     sex: sex,
                     activityLevel: activityLevel,
                     weightUnit: data.weight.units,
                     bulletPoints: calculatedData.paywallBullets,
                     descriptionPoints: [
                        .init(type: .text(age),
                              description: String(
                                format: NSLocalizedString("PersonalizedPaywall.description.1", comment: ""),
                                arguments: [sex.paywallTitle, age]
                              )),
                        .init(type: .image(.figureWalk),
                              description: String(
                                format: NSLocalizedString("PersonalizedPaywall.description.2", comment: ""),
                                activityLevel.title.lowercased()
                              ))
                     ]
        )
    }

    func save(data: OnboardingData) {
        self.data = data
        saveDataInWidgets(data: data)
        calculate()
    }

    func reset() {
        data = nil
        calculatedData = nil
    }

    private func saveDataInWidgets(data: OnboardingData) {
        coachService.updateUserData(data.aiCoachUserData)
        Task {
            let weightHistory = WeightHistory(scaleWeightValue: data.weight.value,
                                              trueWeightValue: 0,
                                              weightUnits: data.weight.units,
                                              historyDate: .now)
            let savedHistory = try await weightService.save(history: weightHistory)

            let weightGoal = WeightGoal(goal: data.desiredWeight.value,
                                        weightUnit: data.desiredWeight.units)
            _ = try await weightGoalService.save(weightGoal)
        }
    }

    private func calculate() {
        guard let data else { return }

        let weightPerDay = data.weight.value * 0.00143
        let dropWeight = data.weight.value - data.desiredWeight.value
        let daysToDrop = dropWeight / weightPerDay
        let dropWeightDate = Date().add(days: Int(daysToDrop))
        var specialEventWeight: WeightMeasure?
        var eventDropWeightMeasure: WeightMeasure?

        if let event = data.specialEventDate {
            let daysToEvent = event.timeIntervalSinceNow.hours / 24
            let eventWeight = max(data.weight.value - CGFloat(daysToEvent) * weightPerDay, data.desiredWeight.value)
            specialEventWeight = .init(value: eventWeight, units: data.weight.units)
            eventDropWeightMeasure = .init(value: data.weight.value - eventWeight, units: data.weight.units)
        }

        let paywallTitle = paywallTitle(desiredWeightDate: dropWeightDate)
        let bullets = paywallBullets(dropWeight: eventDropWeightMeasure)
        let fromAges = fromAgesTitle(birthday: data.birthdayDate ?? .now)

        let baseWaterIntake = data.weight.normalizeValue / 0.03
        let waterIntake = baseWaterIntake + data.activityLevel.waterLevel

        calculatedData = OnboardingCalculatedData(
            specialEventWeight: specialEventWeight,
            desiredWeightDate: dropWeightDate,
            paywallTitle: paywallTitle,
            paywallBullets: bullets,
            fromAgesTitle: fromAges,
            waterIntake: waterIntake
        )
    }

    private func fromAgesTitle(birthday: Date) -> String {
        let ageComponents = Calendar.current.dateComponents([.year], from: birthday, to: .now)
        let age = ageComponents.year ?? 35
        return "\(Int(age / 5) * 5)+"
    }

    private func paywallBullets(dropWeight: WeightMeasure?) -> [String] {
        guard let data else { return [] }
        var bullets = [String]()

        if let dropWeight, dropWeight.value >= 2, data.specialEvent != .noSpecialEvent {
            let event = data.specialEventDate == nil ? SpecialEvent.birthday : data.specialEvent
            let eventTitle = event.eventName.lowercased()
            let weightTitle = NSLocalizedString("OnboardingService.bulletWeight.title",
                                                comment: "Lose ~3 kg by your birthday! ")
            bullets.append(String(format: weightTitle, dropWeight.wholeValueWithUnits, event.eventArticle, eventTitle))
        }

        var availableBullets = FastingGoal.availableBullets
        for goal in data.goals {
            if bullets.count >= 4 { break }
            if let bullet = availableBullets.removeValue(forKey: goal) {
                bullets.append(bullet)
            }
        }

        while bullets.count < 4 {
            let dropped = availableBullets.popFirst()
            guard let goal = dropped?.value else {
                break
            }
            bullets.append(goal)
        }
        return bullets
    }

    private func paywallTitle(desiredWeightDate: Date) -> String {
        guard let data else { return "" }
        let title = NSLocalizedString("OnboardingService.paywallTitle",
                                      comment: "Reach your dream weight of 52 kg by February 14")

        return String(
            format: title,
            data.desiredWeight.wholeValueWithUnits,
            desiredWeightDate.currentLocaleFormatted(
                with: desiredWeightDate.year == Date().year ? "MMMM dd" : " MMMM dd yyyy"
            )
        )
    }
}

private extension OnboardingData {
    var aiCoachUserData: AICoachUserData {
        .init(currentWeight: weight.valueWithUnits,
              goalWeight: desiredWeight.valueWithUnits,
              height: height.valueWithUnits,
              dateOfBirth: birthdayDate ?? .now,
              sex: sex.rawValue)
    }
}
