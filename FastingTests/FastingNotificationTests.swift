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

    override func setUp() async throws { try await super.setUp() }

    override func tearDown() async throws { try await super.tearDown() }

    func testCalculateDatesBeforeFastingStart() async throws {}
}
