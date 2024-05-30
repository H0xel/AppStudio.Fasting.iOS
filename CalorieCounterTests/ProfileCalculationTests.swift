//
//  ProfileCalculationTests.swift
//  CalorieCounterTests
//
//  Created by Denis Khlopin on 28.12.2023.
//

import XCTest
@testable import CalorieCounter
import Dependencies
import AppStudioModels

final class ProfileCalculationTests: XCTestCase {
    @Dependency(\.profileCalculationServiceService) var profileCalculationServiceService

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testTDDCreateServices() throws {
        let initial = ProfileCalculationInitialData(sex: .male,
                                                    birthday: .now,
                                                    height: .init(value: 180, units: .cm),
                                                    weight: .init(value: 107),
                                                    activityLevel: .sedentary,
                                                    exerciseActivity: .sessionsPerWeek1to3,
                                                    activityType: .cardio)

        let calories = profileCalculationServiceService.calculateMaintainEstimatedExpenditure(initialData: initial)
        print(calories)

        let goalData = ProfileCalculationGoalData(targetWeight: .init(value: 90), calorieGoal: .lose)
        let speedRange = profileCalculationServiceService.calculateSpeedRange(initialData: initial, goalData: goalData)

        print(speedRange)

        let speed = WeightMeasure(value: speedRange.startingPoint / 7)
        let dailyCalories = profileCalculationServiceService.calculateDailyCaloriesAndDate(
            initialData: initial,
            goalData: goalData,
            weightPerDaySpeed: speed
        )

        print(dailyCalories)
        let dietData = ProfileCalculationDietData(proteinLevel: .high, dietType: .balanced)

        let result = profileCalculationServiceService.calculate(initialData: initial,
                                                                goalData: goalData,
                                                                weightPerDaySpeed: speed,
                                                                dietData: dietData)

        print(result)
    }
}
