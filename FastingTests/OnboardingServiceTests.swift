//
//  OnboardingServiceTests.swift
//  FastingTests
//
//  Created by Denis Khlopin on 12.12.2023.
//

import XCTest
import Dependencies
@testable import Fasting

final class OnboardingServiceTests: XCTestCase {
    @Dependency(\.onboardingService) var onboardingService

    override func setUp() async throws { try await super.setUp() }

    override func tearDown() async throws { try await super.tearDown() }

    func testSaveData() async throws {
        onboardingService.save(
            data: OnboardingData(
                goals: [.loseWeight, .lookBetter, .liveLonger],
                sex: .female,
                birthdayDate: Date(dateString: "1979-12-12", timeString: "00:00:00") ?? .now,
                height: .init(value: 80, units: .cm),
                weight: .init(value: 90, units: .kg),
                desiredWeight: .init(value: 75, units: .kg),
                activityLevel: .lightlyActive,
                specialEvent: .birthday,
                specialEventDate: Date(dateString: "2024-12-12", timeString: "00:00:00")
            )
        )
    }
}
