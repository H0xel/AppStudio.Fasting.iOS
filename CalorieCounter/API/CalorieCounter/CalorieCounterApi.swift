//
//  CalorieCounterApi.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

protocol CalorieCounterApi {
    func food(request: String) async throws -> CaloriesCalculateResponse
    func ingredients(request: String) async throws -> IngredientsResponse
}
