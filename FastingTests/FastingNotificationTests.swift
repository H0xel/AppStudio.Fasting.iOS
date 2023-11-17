//
//  FastingNotificationTests.swift
//  FastingTests
//
//  Created by Denis Khlopin on 14.11.2023.
//

import XCTest
import Dependencies
@testable import Fasting

final class FastingNotificationTests: XCTestCase {
    @Dependency(\.fastingLocalNotificationService) private var fastingLocalNotificationService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.fastingService) private var fastingService

    override func setUp() async throws {}

    override func tearDown() async throws {}

    func testCalculateDatesBeforeFastingStart() async throws {
        let fastingStartDate = Date().addingTimeInterval(.hour * 2)
        fastingService.endFasting()
        fastingParametersService.set(
            fastingInterval: FastingInterval(
                start: fastingStartDate,
                plan: .beginner,
                currentDate: nil
            )
        )

        try await fastingLocalNotificationService.setNotifications()
    }
}