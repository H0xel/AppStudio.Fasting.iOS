//
//  ModelTests.swift
//  PeriodTrackerTests
//
//  Created by Denis Khlopin on 04.09.2024.
//

import XCTest
import Dependencies
@testable import PeriodTracker
import FirebaseRemoteConfig

final class ModelTests: XCTestCase {
    @Dependency(\.menstrualCycleCalendarRepository) var menstrualCycleCalendarRepository

    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        try await menstrualCycleCalendarRepository.set(dates: [.now, .now.add(days: -2)], type: .menstruationDay)

        let dates = try await menstrualCycleCalendarRepository.dates(type: .menstruationDay)
        print(dates)
    }
}

