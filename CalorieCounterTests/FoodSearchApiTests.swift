//
//  FoodSearchApiTests.swift
//  CalorieCounterTests
//
//  Created by Denis Khlopin on 18.01.2024.
//

import XCTest
@testable import CalorieCounter
import Dependencies

final class FoodSearchApiTests: XCTestCase {
    @Dependency(\.foodSearchApi) var foodSearchApi
    @Dependency(\.foodSearchService) var foodSearchService
    @Dependency(\.codableCacheRepository) var codableCacheRepository

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testApi() async throws {
        let array = ["813868020130",
                     "071481042001",
                     "02185705",
                     "011153234297",
                     "041331021647",
                     "027000381434",
                     "043000705902"]
        let result = try await foodSearchApi.search(FoodSearchRequest.init(query: array[0]))
    }

    func testService() async throws {
        let resultMeal = try await foodSearchService.search(barcode: "071481042001")
    }

    func testCodableCache() async throws {
        let obj1 = try await codableCacheRepository.set(key: "TEST_KEY", value: "TEST_VALUE_1", for: .default)
        let obj2 = try await codableCacheRepository.set(key: "TEST_KEY", value: "TEST_VALUE_2", for: .default)
        let obj3 = try await codableCacheRepository.set(key: "TEST_KEY", value: "TEST_VALUE_3", for: .default)
        let value = try await codableCacheRepository.value(key: "TEST_KEY", of: .default, cacheInterval: nil)
        XCTAssert(obj1.id == obj2.id)
        XCTAssert(value == "TEST_VALUE_3")

        try await Task.sleep(seconds: 3)
        let oldValue = try await codableCacheRepository.value(key: "TEST_KEY", of: .default, cacheInterval: .second)

        XCTAssert(oldValue == nil)
    }
}
