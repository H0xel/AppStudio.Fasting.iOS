//
//  FastingParametersTests.swift
//  FastingTests
//
//  Created by Denis Khlopin on 31.10.2023.
//

import XCTest
import Dependencies
@testable import Fasting

final class FastingParametersTests: XCTestCase {

    @Dependency(\.fastingParametersRepository) var fastingParametersRepository

    override func setUp() async throws {
        DatabaseInitializer().initialize()
        try await (fastingParametersRepository as? FastingParametersRepositoryImpl)?.deleteAll()
        try await super.setUp()
    }

    override func tearDown() async throws { try await super.tearDown() }

    func testIntervalDataShouldBeEqualAfterCreatingNewCurrentParametersFromInterval() async throws {
        // arrange
        let interval = FastingInterval(start: .now, plan: .beginner)

        // act
        let result = try await fastingParametersRepository.save(interval: interval)

        // assert
        XCTAssert(interval.plan == result.plan)
        XCTAssert(interval.start == result.start)
    }

    func testPlanShouldBeNotNilAndEqualBeginnerWhenWeGetParameterForTheFirstTime() async throws {
        // arrange

        // act
        let initialCurrent = try await fastingParametersRepository.current()

        // assert
        XCTAssert(initialCurrent.plan == .beginner)
    }

    func testEntityIdShouldBeEqualAfterChangingCurrentDate() async throws {
        // arrange
        let currentDate = Date.now.addingMonth
        let interval = FastingInterval(start: .now, plan: .beginner)
        let newParameters = try await fastingParametersRepository.save(interval: interval)

        // act
        let current = try await fastingParametersRepository.current()
        let updated = try await fastingParametersRepository.update(currentDate: currentDate)
        let withClearedDate = try await fastingParametersRepository.clearCurrentDate()

        // assert
        XCTAssert(newParameters.id == current.id)

        XCTAssert(current.id == updated.id)
        XCTAssert(current.currentDate != updated.currentDate)

        XCTAssert(current.id == withClearedDate.id)
        XCTAssert(withClearedDate.currentDate == nil)
    }

    func testEntityIdMustNotBeChangedAfterSavingIntervalWithSameParametersExceptCurrentDate() async throws {
        // arrange
        let date = Date.now
        let plan = FastingPlan.beginner
        let currentDate = Date.now.addingMonth
        let anotherDate = Date.now.adding(.minute, value: 12)
        let initialInterval = FastingInterval(start: date, plan: plan, currentDate: currentDate)
        let updatedInterval = FastingInterval(start: date, plan: plan, currentDate: anotherDate)
        let updatedIntervalWithoutCurrentDate = FastingInterval(start: date, plan: plan, currentDate: nil)
        let initialParameters = try await fastingParametersRepository.save(interval: initialInterval)

        // act
        let updatedParameters = try await fastingParametersRepository.save(interval: updatedInterval)
        let updatedParametersWithoutDate = try await fastingParametersRepository.save(
            interval: updatedIntervalWithoutCurrentDate
        )

        // assert
        XCTAssert(initialParameters.id == updatedParameters.id)
        XCTAssert(initialParameters.currentDate != updatedParameters.currentDate)

        XCTAssert(updatedParameters.id == updatedParametersWithoutDate.id)
        XCTAssert(updatedParametersWithoutDate.currentDate == nil)
    }

    func testEntityIdMustBeChangedAfterSavingNewCnangedInterval() async throws {
        // arrange
        let date = Date.now
        let anotherDate = Date.now.addingMonth
        let interval = FastingInterval(start: date, plan: .beginner)
        let newInterval = FastingInterval(start: date, plan: .expert)
        let anotherInterval = FastingInterval(start: anotherDate, plan: .expert)
        let initialParameters = try await fastingParametersRepository.save(interval: interval)

        // act
        let updatedPlanParamenters = try await fastingParametersRepository.save(interval: newInterval)
        let updatedDateParamenters = try await fastingParametersRepository.save(interval: anotherInterval)

        // assert
        XCTAssert(initialParameters.id != updatedPlanParamenters.id)
        XCTAssert(updatedPlanParamenters.id != updatedDateParamenters.id)
    }

    func testCurrentParametersMustHaveTheLatestCreationDate() async throws {
        // arrange
        let date = Date.now
        let anotherDate = Date.now.addingMonth

        let interval = FastingInterval(start: date, plan: .beginner)
        let newInterval = FastingInterval(start: date, plan: .expert)
        let anotherNewInterval = FastingInterval(start: anotherDate, plan: .regular)

        // act
        let parameters = try await fastingParametersRepository.save(interval: interval)
        let newParameters = try await fastingParametersRepository.save(interval: newInterval)
        let anotherParameters = try await fastingParametersRepository.save(interval: anotherNewInterval)

        let current = try await fastingParametersRepository.current()

        // assert
        XCTAssert(current.id != parameters.id)
        XCTAssert(current.id != newParameters.id)
        XCTAssert(current.id == anotherParameters.id)

        XCTAssert(current.creationDate > newParameters.creationDate)
        XCTAssert(current.creationDate > parameters.creationDate)
    }
}
