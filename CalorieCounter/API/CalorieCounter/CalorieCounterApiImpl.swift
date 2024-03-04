//
//  CalorieCounterApiImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

class CalorieCounterApiImpl: CalorieCounterApi {
    private let provider = TelecomApiProvider<CalorieCounterTarget>()

    func food(request: String) async throws -> CaloriesCalculateResponse {
        try await provider.request(.calculate(.init(foodText: request, promptType: .food)))
    }

    func ingredients(request: String) async throws -> IngredientsResponse {
        try await provider.request(.calculate(.init(foodText: request, promptType: .ingredients)))
    }
}
